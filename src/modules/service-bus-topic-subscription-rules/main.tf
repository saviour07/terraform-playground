resource "azurerm_servicebus_subscription_rule" "sb_topic_sub_rule_sql" {
  name                = "${var.sb_name}.${var.topic_name}.${var.msg_name}.${var.msg_version}"
  resource_group_name = var.rg_name
  namespace_name      = var.sb_name
  topic_name          = var.topic_name
  subscription_name   = var.sub_name
  filter_type         = "SqlFilter"
  sql_filter          = var.sql_filter
}
