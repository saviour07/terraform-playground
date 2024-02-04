# Azure Service Bus module

Creates an Azure service bus resource, with the option of creating a root topic and subscription rule.
If a root topic and subscription rule are not provided then only the service bus resource is created.

## Inputs
| Name                  | Type      | Required  | Available Values          | Default Value |
|-----------------------|-----------|-----------|---------------------------|---------------|
| resource_group_name   | string    | Yes       | N/A                       | N/A           |
| location              | string    | Yes       | N/A                       | N/A           |
| name                  | string    | Yes       | N/A                       | N/A           |
| sku                   | string    | Yes       | Basic/Standard/Premium    | N/A           |
| root_topic            | object    | No        | N/A                       | N/A           |

### Root Topic
The root topic object is a complex object which is defined as follows:
{
    root topic properties
    root subscription: {
        root subscription properties
        sql filter: {
            filter
        }
        correlation filter: {
            filter
        }
    }
}

Both the root topic and it's subscription are optional, however it is recommended that if a root topic is created, that at least a single subscription is created to avoid the `$Default` subscription from being created which will capture everything.

## Outputs
| Name                                      | Secret    |
|-------------------------------------------|-----------|
| service_bus_namespace_id                  | No        |
| service_bus_name                          | No        |
| service_bus_connection_string             | Yes       |
| service_bus_root_topic_id                 | No        |
| service_bus_root_topic_connection_string  | Yes       |

