resource "azurerm_servicebus_namespace" "sb" {
  name                = "${var.prefix}service-bus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}
