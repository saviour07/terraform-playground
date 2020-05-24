provider "azurerm" {
    version = "~> 2.1.0"
    features {}
}

module "resource_group" {
    source = "../modules/resource-groups"

    rg_location = var.rg_location
    rg_prefix = var.rg_prefix
    rg_name = var.rg_name
    rg_tags = var.rg_tags
}
