locals {
    msg_props = {
        domain  = "X-MsgDomain"
        name    = "X-MsgName"
        version = "X-MsgVersion"
    }
    msg_values = {
        domain   = "Internal"
    }
}

module "internal_topic_subscription_rule" {
    source = "../service-bus-topic-subscription-rules"

    rg_name     = var.rg_name
    sb_name     = var.sb_name
    topic_name  = var.topic_name
    sub_name    = var.sub_name
    msg_name    = var.msg_name
    msg_version = var.msg_version
    sql_filter  = join(" AND ", [
    "${local.msg_props["domain"]}='${local.msg_values["domain"]}'",
    "${local.msg_props["name"]}='${var.msg_name}'",
    "${local.msg_props["version"]}='${var.msg_version}'"
  ])
}
