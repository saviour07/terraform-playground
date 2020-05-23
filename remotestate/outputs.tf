output "tfstateaccountkey" {
    value = azurerm_storage_account.sa.primary_access_key
}

output "tfstatecontainerid" {
    value = azurerm_storage_container.sacontainer.id
}
