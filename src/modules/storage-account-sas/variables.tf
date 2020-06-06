variable "sa_connection_string" {
    type = string
}

variable "https" {
    type = bool
    default = false
}

variable "expiry_start" {
    type = string
}

variable "expiry_end" {
    type = string
}

variable "resource_types_object" {
    type = bool
    default = false
}

variable "resource_types_container" {
    type = bool
    default = false
}

variable "resource_types_service" {
    type = bool
    default = false
}

variable "services_blob" {
    type = bool
    default = false
}

variable "services_queue" {
    type = bool
    default = false
}

variable "services_table" {
    type = bool
    default = false
}

variable "services_file" {
    type = bool
    default = false
}

variable "permissions_read" {
    type = bool
    default = false
}

variable "permissions_write" {
    type = bool
    default = false
}

variable "permissions_delete" {
    type = bool
    default = false
}

variable "permissions_list" {
    type = bool
    default = false
}

variable "permissions_add" {
    type = bool
    default = false
}

variable "permissions_create" {
    type = bool
    default = false
}

variable "permissions_update" {
    type = bool
    default = false
}

variable "permissions_process" {
    type = bool
    default = false
}
