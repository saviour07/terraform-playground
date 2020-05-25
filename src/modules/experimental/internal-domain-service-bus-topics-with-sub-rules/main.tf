locals {
    msg_props = {
        domain  = "X-MsgDomain"
        name    = "X-MsgName"
        version = "X-MsgVersion"
    }

    domain = "internal"

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
        }
    ]

// TODO:
// Iterate over all topics to generate the subscriptions
    subscriptions = [
        {
            sub_name = "${local.domain}.${local.topics[0].name}.${local.topics[0].messages[0].name}.v${local.topics[0].messages[0].versions[0].major}"
            topic_name = local.topics[0].name
            message_name = local.topics[0].messages[0].name
            max_delivery_count = local.topics[0].max_delivery_count
        }
    ]

// TODO:
// Iterate over all the subscriptions to generate the rules
    rules = [
        {
            sub_name = local.subscriptions[0].sub_name
            topic_name = local.subscriptions[0].topic_name
            sql_filter = join(" AND ", [
                "${local.msg_props["domain"]}='${local.domain}'",
                "${local.msg_props["name"]}='${local.topics[0].name}'",
                join(" OR ", [
                    for v in local.topics[0].messages[0].versions[0].minors : 
                        "${local.msg_props["version"]}='${v}'"
                ])
            ])
        }
    ]

    /*
    // Below generates a tuple of objects
    subscriptions = flatten([
        for topic_name, topic in var.topics : [
            for message in topic.messages : [
                for major_version, version in message.versions : {
                    topic_name = topic_name
                    message_name = message.name
                    sub_name = "${var.domain}.${topic_name}.${message.name}.v${major_version}"
                    max_delivery_count = topic.max_delivery_count
                }
            ]
        ]
    ])
    */
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
