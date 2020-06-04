output "name" {
    value = azurerm_storage_account.sa.name
}

output "key" {
    value = azurerm_storage_account.sa.primary_access_key
    sensitive = true
}
