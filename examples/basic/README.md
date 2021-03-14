# Basic Example

This is an example of how to use the Datalab module to create a Cloud Datalab
instance with default settings.

It will do the following:
- Create a VPC
- Create a Cloud NAT and Cloud Router
- Create a private ip Datalab instance with default settings

Expected variables:
- `datalab_user_email`
- `project_id`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| boot\_disk\_size\_gb | The boot disk size in gb for the Datalab instance | `number` | `20` | no |
| create\_disk | Create a persistent data disk | `bool` | `true` | no |
| create\_fw\_rule | Flag to create Firewall rule for SSH access to Datalab | `bool` | `true` | no |
| datalab\_console\_log\_level | The log level for which log entries from the Datalab instance will be written to StackDriver logging. Valid choices: (trace,debug,info,warn,error,fatal) | `string` | `"warn"` | no |
| datalab\_docker\_image | Datalab docker image to use | `string` | `"gcr.io/cloud-datalab/datalab:latest"` | no |
| datalab\_enable\_backup | Automatically backup the disk contents to Cloud Storage | `bool` | `true` | no |
| datalab\_enable\_swap | Enable swap on the Datalab instance | `bool` | `true` | no |
| datalab\_gpu\_docker\_image | Datalab GPU docker image to use | `string` | `"gcr.io/cloud-datalab/datalab-gpu:latest"` | no |
| datalab\_idle\_timeout | Interval after which an idle Datalab instance will shut down. You can specify a mix of days, hours, minutes and seconds using those names or d, h, m and s, for example 1h 30m. Specify 0s to disable | `string` | `"60m"` | no |
| datalab\_user\_email | Create the Datalab instance on behalf of the specified user | `any` | n/a | yes |
| enable\_secure\_boot | Verify the digital signature of all boot components, and halt the boot process if signature verification fails | `bool` | `false` | no |
| fluentd\_docker\_image | Fluentd docker image to use | `string` | `"gcr.io/google-containers/fluentd-gcp:2.0.17"` | no |
| gpu\_count | Number of GPUs for the Datalab instance. Valid values are: 0, 1, 2, 4, 8 | `number` | `0` | no |
| gpu\_type | The GPU type for the Datalab instance | `string` | `"nvidia-tesla-k80"` | no |
| labels | A map of key/value label pairs to assign to the instance. | `map(string)` | `{}` | no |
| machine\_type | The machine type for the Datalab instance | `string` | `"n1-standard-2"` | no |
| name | The name of the Datalab instance | `string` | `"datalab"` | no |
| network\_name | The name of the VPC network being created | `string` | `"datalab-network"` | no |
| persistent\_disk\_size\_gb | The persistent disk size in gb for the Datalab instance | `number` | `200` | no |
| project\_id | The project ID used for the Datalab instance | `any` | n/a | yes |
| region | The region the network will be created in | `string` | `"us-central1"` | no |
| service\_account | The service account attached to the Datalab instance. If empty the default Google Compute Engine service account is used | `any` | `null` | no |
| zone | The zone the Datalab instance will be deployed to | `string` | `"us-central1-c"` | no |

## Outputs

| Name | Description |
|------|-------------|
| disk\_name | The name of the persistent disk |
| disk\_size | The size of the persistent disk |
| firewall\_name | The name of the firewall rule |
| instance\_name | The instance name |
| labels | A map of key/value label pairs to assigned to the instance. |
| nat\_name | Google Cloud NAT name |
| network\_name | Network name |
| router\_name | Google Cloud Router name |
| subnet\_name | Subnet name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
