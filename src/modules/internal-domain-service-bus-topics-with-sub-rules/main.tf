locals {
    msg_props = {
        domain  = "MsgDomain"
        name    = "MsgName"
        version = "MsgVersion"
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
                        "(${join(" OR ", [for v in version.minors : "${local.msg_props["version"]}='${v}'" ])})"
                    ])
                }
            ]
        ]
    ])
}

module "internal_topic_subscriptions_with_sql_rules" {
    source = "../service-bus-topic-subscriptions"

    rg_name = var.rg_name
    sb_name = var.sb_name
    topics = local.topics
    subscriptions = local.subscriptions
}
