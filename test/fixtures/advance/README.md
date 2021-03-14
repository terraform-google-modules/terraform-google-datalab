Expected variables:
- `project_id`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| datalab\_service\_account\_email | The service account attached to the Datalab instance. If empty the default Google Compute Engine service account is used | `any` | `null` | no |
| datalab\_user\_email | Create the Datalab instance on behalf of the specified user | `string` | `"integration-test@google.com"` | no |
| project\_id | The ID of the project in which to provision resources. | `any` | n/a | yes |
| region | The region the network will be created in | `string` | `"us-central1"` | no |
| zone | The zone the Datalab instance will be deployed to | `string` | `"us-central1-c"` | no |

## Outputs

| Name | Description |
|------|-------------|
| disk\_name | The name of the persistent disk |
| disk\_size | The size of the persistent disk |
| firewall\_name | The name of the firewall rule |
| gpu\_count | Number of gpus |
| gpu\_type | The gpu type |
| instance\_name | The instance name |
| nat\_name | Google Cloud NAT name |
| network\_name | Network name |
| project\_id | The ID of the project in which resources are provisioned. |
| region | Region |
| router\_name | Google Cloud Router name |
| subnet\_name | Subnet name |
| test\_label\_name | n/a |
| test\_label\_value | n/a |
| zone | Zone |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
