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

variable "inbox_topic_name" {
    type = string
}

variable "inbox_topic_enable_partitioning" {
    type = bool
}

variable "inbox_topic_requires_duplicate_detection" {
    type = bool
}
