provider "azurerm" {
    version = "~> 2.1.0"
    features {}
}

resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}remotestate"
    location = var.location
    tags = var.tags
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.prefix}satfstate"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_kind             = "BlobStorage"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sacontainer" {
  name                  = "${var.prefix}tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
