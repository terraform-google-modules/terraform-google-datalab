# Google Cloud Private Datalab‎ instance

This module allows you to create opinionated Google Cloud Datalab CPU or GPU instances.

The resources/services/activations/deletions that this module will create/trigger are:
- Create a firewall rule to allow [Cloud IAP for TCP forwarding](https://cloud.google.com/iap/docs/using-tcp-forwarding)
- Create a private GCE Datalab instance with GPUs attached.

## Usage

Basic usage of this module is as follows:

```hcl
module "datalab_gpu" {
  source                    = "terraform-google-modules/datalab/google//modules/gpu_instance"
  version                   = "~> 0.1"
  project_id                = "<PROJECT ID>"
  zone                      = "us-central1-c"
  datalab_user_email        = "<DATALAB USER EMAIL>
  network_name              = "datalab-network"
  subnet_name               = "datalab-subnetwork"
  service_account           = <SERVICE ACCOUNT EMAIL>
  machine_type              = "n1-standard-2"
  boot_disk_size_gb         = 20
  persistent_disk_size_gb   = 200
  gpu_instance              = true
  gpu_type                  = "nvidia-tesla-k80"
  gpu_count                 = 1
  datalab_docker_image      = "gcr.io/cloud-datalab/datalab-gpu:latest"
  fluentd_docker_image      = "gcr.io/google-containers/fluentd-gcp:2.0.17"
  datalab_enable_swap       = true
  datalab_enable_backup     = true
  datalab_console_log_level = "warn"
  datalab_idle_timeout      = "60m"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| append\_to\_startup\_script | Full path to file with content to be added to the startup script. | `string` | `null` | no |
| boot\_disk\_size\_gb | The boot disk size in gb for the Datalab instance | `number` | `20` | no |
| create\_disk | Create a persistent data disk | `bool` | `true` | no |
| create\_fw\_rule | Flag to create Firewall rule for SSH access to Datalab | `bool` | `true` | no |
| datalab\_console\_log\_level | The log level for which log entries from the Datalab instance will be written to StackDriver logging. Valid choices: (trace,debug,info,warn,error,fatal) | `string` | `"warn"` | no |
| datalab\_docker\_image | Datalab docker image to use. If not set latest gcr.io/cloud-datalab/datalab or datalab-gpu image will be used | `string` | `null` | no |
| datalab\_enable\_backup | Automatically backup the disk contents to Cloud Storage | `bool` | `true` | no |
| datalab\_enable\_swap | Enable swap on the Datalab instance | `bool` | `true` | no |
| datalab\_idle\_timeout | Interval after which an idle Datalab instance will shut down. You can specify a mix of days, hours, minutes and seconds using those names or d, h, m and s, for example 1h 30m. Specify 0s to disable | `string` | `"60m"` | no |
| datalab\_user\_email | Create the Datalab instance on behalf of the specified user | `any` | n/a | yes |
| enable\_secure\_boot | Verify the digital signature of all boot components, and halt the boot process if signature verification fails | `bool` | `false` | no |
| existing\_disk\_name | Name of an existing persistent disk you want to use | `any` | `null` | no |
| fluentd\_docker\_image | Fluentd docker image to use | `string` | `"gcr.io/google-containers/fluentd-gcp:2.0.17"` | no |
| gpu\_count | Number of GPUs for the Datalab instance. Valid values are: 0, 1, 2, 4, 8. Only applicable when gpu\_instance is true | `number` | `0` | no |
| gpu\_instance | Whether or not create GPU instance instead of a CPU instance | `bool` | `false` | no |
| gpu\_type | The GPU type for the Datalab instance. Only applicable when gpu\_instance is true | `string` | `"nvidia-tesla-k80"` | no |
| labels | A map of key/value label pairs to assign to the instance. | `map(string)` | `{}` | no |
| machine\_type | The machine type for the Datalab instance | `string` | `"n1-standard-2"` | no |
| name | The name of the Datalab instance | `string` | `"datalab"` | no |
| network\_name | The network the Datalab instance will be in | `any` | n/a | yes |
| persistent\_disk\_size\_gb | The persistent disk size in gb for the Datalab instance | `number` | `200` | no |
| project\_id | The project ID used for the Datalab instance | `any` | n/a | yes |
| service\_account | The service account attached to the Datalab instance. If empty the default Google Compute Engine service account is used | `any` | `null` | no |
| subnet\_name | The subnet the Datalab instance will be in | `any` | n/a | yes |
| zone | The zone the Datalab instance will be deployed to | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| disk\_name | The name of the persistent disk |
| disk\_size | The size of the persistent disk |
| firewall\_name | The name of the firewall rule |
| instance\_name | The instance name |
| labels | A map of key/value label pairs to assigned to the instance. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
