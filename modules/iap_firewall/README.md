# Google Cloud Private Datalab‎ IAP Firewall

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_rule | Flag to create or skip Firewall rule creation | `bool` | `true` | no |
| firewall\_description | Description for firewall rule | `string` | `"Allow IAP access"` | no |
| network\_name | The network the Datalab instance will be in | `string` | n/a | yes |
| ports | A list of ports to which this rule applies | `list(any)` | n/a | yes |
| project\_id | The project ID used for the Datalab instance | `string` | n/a | yes |
| target\_tags | A list of instance tags indicating sets of instances located in the network that may make network connections as specified | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| firewall\_name | The name of the firewall rule |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
