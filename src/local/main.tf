terraform {
    backend "azurerm" {
    // These values need to be set by the terraform init
    // command using the -backend-config options.
    // resource_group_name = env:TF_VARS_backend_rg_name
    // storage_account_name = env:TF_VARS_backend_sa_name
    // container_name = env:TF_VARS_backend_container_name
    // access_key = env:TF_VARS_backend_sa_key
    // key = terraform.tfstate
    }
    required_providers {
        azurerm = "~> 2.1.0"
    }
}

provider "azurerm" {
    version = "~> 2.1.0"
    features {}
}

resource "random_string" "uid" {
  length = 8
  lower = true
  upper = false
  number = true
  special = false
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
  rg_name             = module.resource_group.rg_name
  sa_location         = var.sa_location
  sa_account_tier     = var.sa_account_tier
  sa_account_kind     = var.sa_account_kind
  sa_replication_type = var.sa_replication_type
}

module "service_bus" {
    source = "../modules/service-bus"

    sb_location = var.sb_location
    sb_prefix   = var.sb_prefix
    sb_name     = "${var.sb_name}${random_string.uid.result}"
    sb_sku      = var.sb_sku
    rg_name     = module.resource_group.rg_name
}
