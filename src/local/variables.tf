variable "rg_location" {
    type = string
}

variable "rg_prefix" {
    type = string
}

variable "rg_name" {
    type = string
}

variable "rg_tags" {
    type = map
}

variable "sa_location" {
    type = string
}

variable "sa_prefix" {
    type = string
}

variable "sa_name" {
    type = string
}

variable "sa_account_tier" {
    type = string
}

variable "sa_account_kind" {
    type = string
}

variable "sa_replication_type" {
    type = string
}

variable "sb_location" {
    type = string
}

variable "sb_prefix" {
    type = string
}

variable "sb_name" {
    type = string
}

variable "sb_sku" {
    type = string
}

variable "service_plan_name" {
    type = string
}

variable "service_plan_location" {
    type = string
}

variable "service_plan_sku_tier" {
    type = string
}

variable "service_plan_sku_size" {
    type = string
}

variable "fn_app_location" {
    type = string
}

variable "fn_app_name" {
    type = string
}

variable "fn_sa_container_name" {
    type = string
}

variable "fn_sa_container_access_type" {
    type = string
}

variable "fn_blob_name" {
    type = string
}

variable "fn_blob_type" {
    type = string
}

variable "fn_blob_path" {
    type = string
}

variable "fn_https" {
    type = bool
}

variable "fn_edit_mode" {
    type = string
}

variable "fn_runtime" {
    type = string
}

variable "fn_runtime_version" {
    type = string
}

variable "fn_sas_https" {
    type = bool
}

variable "fn_sas_expiry_start" {
    type = string
}

variable "fn_sas_expiry_end" {
    type = string
}

variable "fn_sas_resource_types_object" {
    type = bool
}

variable "fn_sas_resource_types_container" {
    type = bool
}

variable "fn_sas_resource_types_service" {
    type = bool
}

variable "fn_sas_services_blob" {
    type = bool
}

variable "fn_sas_services_queue" {
    type = bool
}

variable "fn_sas_services_table" {
    type = bool
}

variable "fn_sas_services_file" {
    type = bool
}

variable "fn_sas_permissions_read" {
    type = bool
}

variable "fn_sas_permissions_write" {
    type = bool
}

variable "fn_sas_permissions_delete" {
    type = bool
}

variable "fn_sas_permissions_list" {
    type = bool
}

variable "fn_sas_permissions_add" {
    type = bool
}

variable "fn_sas_permissions_create" {
    type = bool
}

variable "fn_sas_permissions_update" {
    type = bool
}

variable "fn_sas_permissions_process" {
    type = bool
}
