locals {
    msg_props = {
        domain  = "MsgDomain"
        name    = "MsgName"
        version = "MsgTypeVersion"
        sender  = "Sender"
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
                    sql_filter = join(" AND ", [
                        "${local.msg_props["domain"]}='${local.domain}'",
                        "${local.msg_props["name"]}='${topic.name}'",
                        "${local.msg_props["sender"]}='${local.domain}.${topic.name}'",
                        "(${join(" OR ", [for v in version.minors : "${local.msg_props["version"]}='${v}'" ])})"
                    ])
                }
            ]
        ]
    ])
}

module "test_domain_topic_subscriptions_with_sql_rules" {
    source = "../service-bus-topic-subscriptions"

    rg_name = var.rg_name
    sb_name = var.sb_name
    topics = local.topics
    subscriptions = local.subscriptions
}
