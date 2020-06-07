module "function_app_sa_sas" {
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

  sa_sas = module.function_app_sa_sas.sas
  sa_conn_string = module.storage_account.connection_string
}
