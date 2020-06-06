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

module "storage_account_sas" {
  source = "../modules/storage-account-sas"

  sa_connection_string = module.storage_account.connection_string

  https = var.fn_sas_https
  expiry_start = var.fn_sas_expiry_start
  expiry_end = var.fn_sas_expiry_end

  resource_types_object = var.fn_sas_resource_types_object
  resource_types_container = var.fn_sas_resource_types_container
  resource_types_service = var.fn_sas_resource_types_service

  services_blob = var.fn_sas_services_blob
  services_queue = var.fn_sas_services_queue
  services_table = var.fn_sas_services_table
  services_file = var.fn_sas_services_file

  permissions_read = var.fn_sas_permissions_read
  permissions_write = var.fn_sas_permissions_write
  permissions_delete = var.fn_sas_permissions_delete
  permissions_list = var.fn_sas_permissions_list
  permissions_add = var.fn_sas_permissions_add
  permissions_create = var.fn_sas_permissions_create
  permissions_update = var.fn_sas_permissions_update
  permissions_process = var.fn_sas_permissions_process
}

module "function_app" {
  source = "../modules/azure-function-app"

  rg_name = module.resource_group.rg_name

  sa_name = module.storage_account.name
  sa_container_name = var.fn_sa_container_name
  sa_container_access_type = var.fn_sa_container_access_type

  service_plan_name = var.service_plan_name
  service_plan_location = var.service_plan_location
  sku_tier = var.service_plan_sku_tier
  sku_size = var.service_plan_sku_size

  function_app_location = var.fn_app_location
  function_app_name = "${var.fn_app_name}${random_string.uid.result}"
  function_blob_name = var.fn_blob_name
  function_blob_type = var.fn_blob_type
  function_blob_path = var.fn_blob_path
  function_https = var.fn_https
  function_runtime = var.fn_runtime
  function_runtime_version = var.fn_runtime_version

  sa_sas = module.storage_account_sas.sas
  sa_conn_string = module.storage_account.connection_string
}

module "service_bus" {
    source = "../modules/service-bus"

    sb_location = var.sb_location
    sb_prefix   = var.sb_prefix
    sb_name     = "${var.sb_name}${random_string.uid.result}"
    sb_sku      = var.sb_sku
    rg_name     = module.resource_group.rg_name
}

module "internal_domain_topics" {
    source = "../modules/internal-domain-service-bus-topics-with-sub-rules"

    rg_name = module.resource_group.rg_name
    sb_name = module.service_bus.sb_name
}

module "test_domain_topics" {
    source = "../modules/test-domain-service-bus-topics-with-sub-rules"

    rg_name = module.resource_group.rg_name
    sb_name = module.service_bus.sb_name
}
