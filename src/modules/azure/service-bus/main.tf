###################################################################################
# Service Bus
###################################################################################
resource "azurerm_servicebus_namespace" "sb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
}

resource "azurerm_servicebus_namespace_authorization_rule" "auth_rule" {
  name          = "sbAuth"
  namespace_id  = azurerm_servicebus_namespace.sb.id

  listen = true
  send   = true
  manage = false
}

###################################################################################
# Service Bus Root Topic
###################################################################################
resource "azurerm_servicebus_topic" "root_topic" {
  count = var.root_topic != null ? 1 : 0

  name          = var.root_topic.name
  namespace_id  = azurerm_servicebus_namespace.sb.id

  status                        = "Active"
  enable_partitioning           = var.root_topic.enable_partitioning
  max_size_in_megabytes         = var.root_topic.max_size_in_megabytes
  requires_duplicate_detection  = var.root_topic.requires_duplicate_detection
  support_ordering              = var.root_topic.support_ordering
}

resource "azurerm_servicebus_topic_authorization_rule" "auth_rule" {
  count = var.root_topic != null ? 1 : 0

  name      = "${azurerm_servicebus_topic.root_topic[0].name}Auth"
  topic_id  = azurerm_servicebus_topic.root_topic[0].id

  listen = true
  send   = true
  manage = false
}

###################################################################################
# Service Bus Root Topic Subscription
###################################################################################
resource "azurerm_servicebus_subscription" "root_topic_subscriptions" {
  count = var.root_topic.root_subscription != null ? 1 : 0

  name                = var.root_topic.root_subscription.name
  topic_id            = azurerm_servicebus_topic.root_topic[0].id

  status              = "Active"
  max_delivery_count  = var.root_topic.root_subscription.max_delivery_count
}

###################################################################################
# Service Bus Root Topic Subscription SQL Rule
###################################################################################
resource "azurerm_servicebus_subscription_rule" "root_topic_topic_subscription_sql_rule" {
  count = var.root_topic.root_subscription.sql_filter != null ? 1 : 0

  name                = var.root_topic.root_subscription.rule_name
  subscription_id     = azurerm_servicebus_subscription.root_topic_subscriptions[0].id

  filter_type         = "SqlFilter"
  sql_filter          = var.root_topic.root_subscription.sql_filter.filter
}

###################################################################################
# Service Bus Root Topic Subscription Correlation Filter Rule
###################################################################################
resource "azurerm_servicebus_subscription_rule" "root_topic_topic_subscription_sql_rule" {
  count = var.root_topic.root_subscription.correlation_filter != null ? 1 : 0

  name                = var.root_topic.root_subscription.rule_name
  subscription_id     = azurerm_servicebus_subscription.root_topic_subscriptions[0].id

  filter_type         = "CorrelationFilter"
  correlation_filter {
    properties = var.root_topic.root_subscription.correlation_filter.properties
  }
}
