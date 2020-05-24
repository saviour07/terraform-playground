output "sb_inbox_topic_sub_rule_id" {
    value = azurerm_servicebus_subscription_rule.sb_topic_sub_rule_sql.id
}

output "sb_inbox_topic_sub_rule_name" {
    value = azurerm_servicebus_subscription_rule.sb_topic_sub_rule_sql.name
}
