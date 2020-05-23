resource "azurerm_servicebus_namespace" "sb" {
  name                = "${var.prefix}service-bus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

resource "azurerm_servicebus_topic" "inbox_topic" {
  name                         = "inbox"
  resource_group_name          = azurerm_resource_group.rg.name
  namespace_name               = azurerm_servicebus_namespace.sb.name
  enable_partitioning          = true
  requires_duplicate_detection = true
}

resource "azurerm_servicebus_subscription" "inbox_sub" {
  name                = "inboxsub"
  resource_group_name = azurerm_resource_group.rg.name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  topic_name          = azurerm_servicebus_topic.inbox_topic.name
  max_delivery_count  = 1
}

resource "azurerm_servicebus_subscription_rule" "inboxsub_rule" {
  name                = "inboxsubrule"
  resource_group_name = azurerm_resource_group.rg.name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  topic_name          = azurerm_servicebus_topic.inbox_topic.name
  subscription_name   = azurerm_servicebus_subscription.inbox_sub.name
  filter_type         = "SqlFilter"
  sql_filter          = "X-MsgDomain='Test'"
}
