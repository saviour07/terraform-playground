resource "azurerm_storage_blob" "stblob" {
  name                   = var.blob_name
  storage_account_name   = var.sa_name
  storage_container_name = var.sa_container_name
  type                   = var.blob_type
  source                 = var.blob_path
}
