resource "azurerm_servicebus_namespace" "sb" {
  name                = "${var.sb_prefix}${var.sb_name}"
  location            = var.sb_location
  resource_group_name = var.rg_name
  sku                 = var.sb_sku
}

resource "azurerm_servicebus_namespace_authorization_rule" "sbAuthRule" {
  name                = "sbAuth"
  namespace_name      = azurerm_servicebus_namespace.sb.name
  resource_group_name = var.rg_name

  listen = true
  send   = true
  manage = false
}
