output "resource_group_name" {
    value = module.resource_group.name
}

output "storage_account_name" {
    value = module.storage_account.name
}

output "storage_account_key" {
    value = module.storage_account.key
    sensitive = true
}

output "storage_container_name" {
    value = module.storage_container.name
}
