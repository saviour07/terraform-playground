variable "location" {
    type = string
    default = "ukwest"
}

variable "prefix" {
    type = string
    default = "my"
}

variable "tags" {
    type = map
    default = {
        Environment = "Terraform Playground"
        Team = "Local"
    }
}
