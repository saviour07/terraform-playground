locals {
  subscriptions = flatten([
    for topic_name, topic in var.topics : [
      for message in topic.messages : [
        for major_version, version in message.versions : {
          topic_name = topic_name
          message_name = message.name
          sub_name = "${var.domain}.${topic_name}.${message.name}.v${major_version}"
          max_delivery_count = topic.max_delivery_count
        }
      ]
    ]
  ])
}

resource "azurerm_servicebus_subscription" "sb_topic_subscription" {

  for_each = {
    for sub in local.subscriptions : sub.sub_name => sub
  }

  name                = each.key
  resource_group_name = var.rg_name
  namespace_name      = var.sb_name
  topic_name          = each.value.topic_name
  max_delivery_count  = each.value.max_delivery_count
}
