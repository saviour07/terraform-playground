output "resource_group_id" {
    value = azurerm_resource_group.rg.id
}

/*
output "sb_namespace_id" {
    value = azurerm_servicebus_namespace.sb.id
}

output "sb_connection_string" {
    value = azurerm_servicebus_namespace.sb.default_primary_connection_string
}

output "sb_inbox_topic_id" {
    value = azurerm_servicebus_topic.inbox_topic.id
}

output "sb_inbox_topic_sub_id" {
    value = azurerm_servicebus_subscription.inbox_sub.id
}

output "sb_inbox_topic_sub_rule_id" {
    value = azurerm_servicebus_subscription_rule.inboxsub_rule.id
}
*/