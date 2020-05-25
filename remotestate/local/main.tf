provider "azurerm" {
    version = "~> 2.1.0"
    features {}
}

module "resource_group" {
    source = "../modules/resource-groups"

    rg_location = var.rg_location
    rg_prefix   = var.rg_prefix
    rg_name     = var.rg_name
    rg_tags     = var.rg_tags
}

module "storage_account" {
  source = "../modules/storage-account"

  sa_name             = "${var.sa_prefix}${var.sa_name}"
  rg_name             = module.resource_group.name
  sa_location         = var.sa_location
  sa_account_tier     = var.sa_account_tier
  sa_account_kind     = var.sa_account_kind
  sa_replication_type = var.sa_replication_type
}

module "storage_container" {
  source = "../modules/storage-container"

  container_name           = "${var.sa_prefix}${var.sa_container_name}"
  sa_name                  = module.storage_account.name
  sa_container_access_type = var.sa_container_access_type
}
