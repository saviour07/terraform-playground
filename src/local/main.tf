provider "azurerm" {
    version = "~> 2.1.0"
    features {}
}

resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}tfplayground"
    location = var.location
    tags = var.tags
}
