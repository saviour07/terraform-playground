output "topic_names" {
    value = values(azurerm_servicebus_topic.service_bus_topics)[*].name
}
