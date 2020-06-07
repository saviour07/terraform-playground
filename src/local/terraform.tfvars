rg_location = "ukwest"
rg_prefix = "my"
rg_name = "tfplayground"
rg_tags = {
    Environment = "Terraform Playground"
    Team = "Local"
}

sa_location = "ukwest"
sa_prefix = "my"
sa_name = "saplayground"
sa_account_tier = "standard"
sa_account_kind = "StorageV2"
sa_replication_type = "LRS"

fn_sa_container_name = "safncontainer"
fn_sa_container_access_type = "private"

sb_location = "ukwest"
sb_prefix = "my"
sb_name = "sb"
sb_sku = "standard"

service_plan_name = "svcplan"
service_plan_location = "ukwest"
service_plan_sku_tier = "Free" //"Standard"
service_plan_sku_size = "F1"   // "S1"

fn_app_location = "ukwest"
fn_app_name = "fnapp"
fn_blob_name = "fnapp.zip"
fn_blob_type = "Block"
fn_blob_path = "" //"../some-local-path.zip"
fn_https = false
fn_edit_mode = "readonly"
fn_runtime = "dotnet"
fn_runtime_version = "~3"

fn_sas_https = false
fn_sas_expiry_start = "2020-01-01"
fn_sas_expiry_end = "2021-12-31"
fn_sas_resource_types_object = true
fn_sas_resource_types_container = false
fn_sas_resource_types_service = false
fn_sas_services_blob = true
fn_sas_services_queue = false
fn_sas_services_table = false
fn_sas_services_file = false
fn_sas_permissions_read = true
fn_sas_permissions_write = false
fn_sas_permissions_delete = false
fn_sas_permissions_list = false
fn_sas_permissions_add = false
fn_sas_permissions_create = false
fn_sas_permissions_update = false
fn_sas_permissions_process = false
