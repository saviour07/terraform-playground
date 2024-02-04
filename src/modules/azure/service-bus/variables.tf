variable "resource_group_name" {
    type        = string
    description = "(Required) The name of the resource group in which to Changing this forces a new resource to be created. create the namespace."
}

variable "location" {
    type        = string
    description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "name" {
    type        = string
    description = "(Required) Specifies the name of the ServiceBus Namespace resource . Changing this forces a new resource to be created."
}

variable "sku" {
    type        = string
    description = "(Required) Defines which tier to use. Options are Basic, Standard or Premium. Please note that setting this field to Premium will force the creation of a new resource."
}

variable "root_topic" {
    type        = object({
      name                          = string
      enable_partitioning           = bool
      max_size_in_megabytes         = number
      requires_duplicate_detection  = bool
      support_ordering              = bool
      root_subscription             = object({
        name                = string
        max_delivery_count  = number
        rule_name           = string
        sql_filter          = object({
          filter = string
        })
        correlation_filter  = object({
          properties = map(string)
        })
      })
    })
    default     = null
    description = "(Optional) The root service bus topic and subscription rule to create on the service bus."
}

