output "name" {
    value = azurerm_storage_account.sa.name
}

output "connection_string" {
    value = azurerm_storage_account.sa.primary_connection_string
    sensitive = true
}

output "key" {
    value = azurerm_storage_account.sa.primary_access_key
    sensitive = true
}
