module "storage_container" {
  source = "../storage-container"

  container_name           = var.sa_container_name
  sa_name                  = var.sa_name
  sa_container_access_type = var.sa_container_access_type
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.service_plan_name
  location            = var.service_plan_location
  resource_group_name = var.rg_name

  sku {
    tier = var.sku_tier
    size = var.sku_size
  }
}

module "function_app_blob" {
  source = "../storage-blob"

  sa_name = var.sa_name
  sa_container_name = module.storage_container.name

  blob_name = var.function_blob_name
  blob_type = var.function_blob_type
  blob_path = var.function_blob_path
}

locals {
  protocol = var.function_https ? "https" : "http"
}

resource "azurerm_function_app" "function_app" {
  name                      = var.function_app_name
  location                  = var.function_app_location
  resource_group_name       = var.rg_name
  app_service_plan_id       = azurerm_app_service_plan.app_service_plan.id
  storage_connection_string = var.sa_conn_string
  version                   = var.function_runtime_version

  app_settings = {
    https_only = var.function_https
    FUNCTIONS_WORKER_RUNTIME = var.function_runtime
    FUNCTION_APP_EDIT_MODE = var.function_edit_mode
    WEBSITE_RUN_FROM_PACKAGE = "${local.protocol}://${var.sa_name}.blob.core.windows.net/${module.storage_container.name}/${var.function_app_name}${var.sa_sas}"
  }
}
