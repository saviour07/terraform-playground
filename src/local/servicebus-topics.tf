locals {
    topics = [
        {
            name = "Inbox",
            enable_partitioning = true,
            requires_duplicate_detection = true,
            permissions = {
                listen = true,
                send = false,
                manage = false
            }
        },
        {
            name = "Outbox",
            enable_partitioning = true,
            requires_duplicate_detection = true,
            permissions = {
                listen = false,
                send = true,
                manage = false
            }
        }
    ]
}

module "topics" {
    source = "../modules/service-bus-topics"

    rg_name = module.resource_group.rg_name
    sb_name = module.service_bus.sb_name
    topics = local.topics
}
