output "topic_names" {
    value = values(azurerm_servicebus_topic.service_bus_topics)[*].name
}

output "topic_connection_strings" {
    value     = values(azurerm_servicebus_topic_authorization_rule.auth_rule)[*].primary_connection_string
    sensitive = true
}
