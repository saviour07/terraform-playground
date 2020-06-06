output "sb_connection_string" {
    value     = module.service_bus.sb_connection_string
    sensitive = true
}

output "sb_namespace_name" {
    value     = module.service_bus.sb_name
}
