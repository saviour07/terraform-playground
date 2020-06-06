data "azurerm_storage_account_sas" "sas" {
  connection_string = var.sa_connection_string
  https_only = var.https
  start = var.expiry_start
  expiry = var.expiry_end
  resource_types {
      object = var.resource_types_object
      container = var.resource_types_container
      service = var.resource_types_service
  }
  services {
      blob = var.services_blob
      queue = var.services_queue
      table = var.services_table
      file = var.services_file
  }
  permissions {
      read = var.permissions_read
      write = var.permissions_write
      delete = var.permissions_delete
      list = var.permissions_list
      add = var.permissions_add
      create = var.permissions_create
      update = var.permissions_update
      process = var.permissions_process
  }
}
