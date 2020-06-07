output "resource_group_name" {
    value = module.resource_group.rg_name
}

output "storage_account_name" {
    value = module.storage_account.name
}

output "storage_account_connection_string" {
    value     = module.storage_account.connection_string
    sensitive = true
}

output "storage_account_key" {
    value     = module.storage_account.key
    sensitive = true
}

output "service_bus_namespace_name" {
    value = module.service_bus.sb_name
}

output "service_bus_connection_string" {
    value     = module.service_bus.sb_connection_string
    sensitive = true
}

output "topic_names" {
    value = module.topics.topic_names
}

output "topic_connection_strings" {
    value     = module.topics.topic_connection_strings
    sensitive = true
}

output "inbox_subscription_names" {
    value = module.inbox_topic_subscriptions_with_sql_rules.subscription_names
}
