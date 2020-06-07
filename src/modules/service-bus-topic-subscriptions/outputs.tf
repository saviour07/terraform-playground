output "subscription_names" {
    value = values(azurerm_servicebus_subscription.service_bus_topic_subscriptions)[*].name
}

output "subscription_rules" {
    value = values(azurerm_servicebus_subscription_rule.service_bus_topic_subscription_sql_rules)[*].name
}
