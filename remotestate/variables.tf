variable "location" {
    type = string
}

variable "prefix" {
    type = string
    default = "prod"
}

variable "tags" {
    type = map
    default = {
        Environment = "Remote State"
        Team = "TeamName"
    }
}
