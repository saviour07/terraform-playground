###################################################################################
# Service Bus
###################################################################################
output "service_bus_namespace_id" {
    value = azurerm_servicebus_namespace.sb.id
}

output "service_bus_name" {
    value = azurerm_servicebus_namespace.sb.name
}

output "service_bus_connection_string" {
    value     = azurerm_servicebus_namespace_authorization_rule.auth_rule.primary_connection_string
    sensitive = true
}

###################################################################################
# Service Bus Root Topic
###################################################################################
output "service_bus_root_topic_id" {
    value = azurerm_servicebus_topic.root_topic[0].id
}

output "service_bus_root_topic_connection_string" {
    value     = azurerm_servicebus_topic.root_topic[0].primary_connection_string
    sensitive = true
}
