locals {
    inbox_msg_props = {
        domain  = "MsgDomain"
        name    = "MsgName"
        version = "MsgVersion"
    }

    // This validates that the list of topics contains the Inbox topic
    valid_topic_inbox = contains(module.topics.topic_names, "Inbox")

    inbox_messages = [
        {
            topic = "Inbox",
            domain = "internal",
            name = "MsgOne",
            max_delivery_count = 1,
            versions = [
                {
                    major = 1,
                    minors = ["1.0","1.1"]
                },
                {
                    major = 2,
                    minors = ["2.0","2.1","2.2"]
                }
            ]
        },
        {
            topic = "Inbox",
            domain = "external",
            name = "MsgTwo",
            max_delivery_count = 2,
            versions = [
                {
                    major = 1,
                    minors = ["1.0","1.1"]
                },
                {
                    major = 2,
                    minors = ["2.0","2.1","2.2"]
                }
            ]
        }
    ]

    // The following will produce a list of subscription objects,
    // see `modules/service-bus-topic-subscriptions` for an example.
    // To debug the following, run `terraform console` with the input:
    // flatten([for t in local.topics : [for m in t.messages : [ for v in m.versions : { tname = t.name, mname = m.name, ver = v.major }]]])
    inbox_subscriptions = flatten([
        for message in local.inbox_messages : [
            for version in message.versions : {
                sub_name = "${message.domain}.${message.topic}.${message.name}.v${version.major}"
                topic_name = message.topic
                max_delivery_count = message.max_delivery_count
                sql_filter = join(" AND ", [
                    "${local.inbox_msg_props["domain"]}='${message.domain}'",
                    "${local.inbox_msg_props["name"]}='${message.name}'",
                    "(${join(" OR ", [for v in version.minors : "${local.inbox_msg_props["version"]}='${v}'" ])})"
                ])
            }
        ]
    ])
}

module "inbox_topic_subscriptions_with_sql_rules" {
    source = "../modules/service-bus-topic-subscriptions"

    rg_name = module.resource_group.rg_name
    sb_name = module.service_bus.sb_name

    // Use the valid topic inbox variable here to force a dependency between
    // the topics modules and this one.
    // This is a workaround for modules not supporting the "depends_on" keyword.
    subscriptions = local.valid_topic_inbox ? local.inbox_subscriptions : []
}
