variable "rg_name" {
  type = string
}

variable "service_plan_name" {
  type = string
}

variable "service_plan_location" {
  type = string
}

variable "sku_tier" {
  type = string
  default = "Free"
}

variable "sku_size" {
  type = string
  default = "F1"
}

variable "function_app_location" {
  type = string
}

variable "function_app_name" {
  type = string
}

variable "sa_conn_string" {
  type = string
}

variable "sa_sas" {
  type = string
}

variable "sa_container_name" {
  type = string
}

variable "sa_name" {
  type = string
}

variable "sa_container_access_type" {
  type = string
}

variable "function_blob_name" {
  type = string
}

variable "function_blob_type" {
  type = string
}

variable "function_blob_path" {
  type = string
}

variable "function_https" {
  type = bool
  default = true
}

variable "function_edit_mode" {
  type = string
  default = "readonly"
}

variable "function_runtime" {
    type = string
}

variable "function_runtime_version" {
    type = string
    default = "~3"
}
