output "sb_namespace_id" {
    value = azurerm_servicebus_namespace.sb.id
}

output "sb_name" {
    value = azurerm_servicebus_namespace.sb.name
}

output "sb_connection_string" {
    value     = azurerm_servicebus_namespace_authorization_rule.auth_rule.primary_connection_string
    sensitive = true
}
