locals {
    msg_props = {
        domain  = "X-MsgDomain"
        name    = "X-MsgName"
        version = "X-MsgTypeVersion"
        sender  = "X-Sender"
    }

    domain = "test"

    topics = [
        {
            name = "TopicOne",
            enable_partitioning = true,
            requires_duplicate_detection = true,
            max_delivery_count = 1,
            messages = [
                {
                    name = "TopicOneMsgOne",
                    versions = [
                        {
                            major = 1,
                            minors = ["1.0","1.1"]
                        }
                    ]
                }
            ]
        },
        {
            name = "TopicTwo",
            enable_partitioning = true,
            requires_duplicate_detection = true,
            max_delivery_count = 1,
            messages = [
                {
                    name = "TopicTwoMsgOne",
                    versions = [
                        {
                            major = 1,
                            minors = ["1.0", "1.1", "1.2"]
                        },
                        {
                            major = 2,
                            minors = ["2.0"]
                        }
                    ]
                },
                {
                    name = "TopicTwoMsgTwo",
                    versions = [
                        {
                            major = 1,
                            minors = ["1.0"]
                        },
                        {
                            major = 2,
                            minors = ["2.0", "2.1"]
                        },
                        {
                            major = 3,
                            minors = ["3.0"]
                        }
                    ]
                }
            ]
        }
    ]

    // The following will produce a list of subscription objects,
    // see `modules/service-bus-topic-subscriptions` for an example.
    // To debug the following, run `terraform console` with the input:
    // flatten([for t in local.topics : [for m in t.messages : [ for v in m.versions : { tname = t.name, mname = m.name, ver = v.major }]]])
    subscriptions = flatten([
        for topic in local.topics : [
            for message in topic.messages : [
                for version in message.versions : {
                    sub_name = "${local.domain}.${topic.name}.${message.name}.v${version.major}"
                    topic_name = topic.name
                    message_name = message.name
                    max_delivery_count = topic.max_delivery_count
                    
                    // This isn't part of the subscription object but it will just be
                    // discarded when passed to a module which expects a subscription
                    // object and it doesn't recognise this property.
                    // It's more useful to generate the filter here rather than
                    // iterating all these topics again just for the rules.
                    sql_filter = join(" AND ", [
                        "${local.msg_props["domain"]}='${local.domain}'",
                        "${local.msg_props["name"]}='${topic.name}'",
                        "${local.msg_props["sender"]}'${local.domain}.${topic.name}'",
                        join(" OR ", [for v in version.minors : "${local.msg_props["version"]}='${v}'" ])
                    ])
                }
            ]
        ]
    ])

    // The following will produce a list of rule objects,
    // see `modules/service-bus-topic-subscription-rules` for an example.
    // To debug the following, run `terraform console` with the input:
    // flatten([for s in local.subscriptions : { sname = s.sub_name, tname = s.topic_name, filter = s.sql_filter }])
    rules = flatten([
        for subscription in local.subscriptions : {
            sub_name = subscription.sub_name
            topic_name = subscription.topic_name
            sql_filter = subscription.sql_filter
        }])
}

module "topics_test" {
    source = "../service-bus-topics"

    rg_name = var.rg_name
    sb_name = var.sb_name
    topics = local.topics
}

module "subs_test" {
    source = "../service-bus-topic-subscriptions"

    rg_name = var.rg_name
    sb_name = var.sb_name
    subscriptions = local.subscriptions
}

module "rules_test" {
    source = "../service-bus-topic-subscription-rules"

    rg_name = var.rg_name
    sb_name = var.sb_name
    rules = local.rules
}
