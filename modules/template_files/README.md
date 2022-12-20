# Google Cloud Private Datalab‎ Template Files

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| append\_to\_startup\_script | Full path to file with content to be added to the startup script. | `string` | `null` | no |
| cloud\_config | Name of the cloud config template to use | `string` | n/a | yes |
| datalab\_console\_log\_level | The log level for which log entries from the Datalab instance will be written to StackDriver logging. Valid choices: (trace,debug,info,warn,error,fatal) | `string` | `"warn"` | no |
| datalab\_disk\_name | Name of the persistent disk to mount to the Datalab instance | `string` | n/a | yes |
| datalab\_docker\_image | Datalab docker image to use | `string` | `"gcr.io/cloud-datalab/datalab:latest"` | no |
| datalab\_enable\_backup | Automatically backup the disk contents to Cloud Storage | `bool` | `true` | no |
| datalab\_enable\_swap | Enable swap on the Datalab instance | `bool` | `true` | no |
| datalab\_idle\_timeout | Interval after which an idle Datalab instance will shut down. You can specify a mix of days, hours, minutes and seconds using those names or d, h, m and s, for example 1h 30m. Specify 0s to disable | `string` | `"60m"` | no |
| datalab\_user\_email | Create the Datalab instance on behalf of the specified user | `string` | n/a | yes |
| fluentd\_docker\_image | Fluentd docker image to use | `string` | `"gcr.io/google-containers/fluentd-gcp:2.0.17"` | no |
| gpu\_count | Number of GPUs for the Datalab instance. Valid values are: 0, 1, 2, 4, 8 | `number` | `0` | no |
| gpu\_device\_map | Cloud config to map the number of gpu devices | `map(string)` | <pre>{<br>  "gpu_device_0": "",<br>  "gpu_device_1": "       --device /dev/nvidia0:/dev/nvidia0 \\\n",<br>  "gpu_device_2": "       --device /dev/nvidia0:/dev/nvidia0 \\\n       --device /dev/nvidia1:/dev/nvidia1 \\\n",<br>  "gpu_device_4": "       --device /dev/nvidia0:/dev/nvidia0 \\\n       --device /dev/nvidia1:/dev/nvidia1 \\\n       --device /dev/nvidia2:/dev/nvidia2 \\\n       --device /dev/nvidia3:/dev/nvidia3 \\\n",<br>  "gpu_device_8": "       --device /dev/nvidia0:/dev/nvidia0 \\\n       --device /dev/nvidia1:/dev/nvidia1 \\\n       --device /dev/nvidia2:/dev/nvidia2 \\\n       --device /dev/nvidia3:/dev/nvidia3 \\\n       --device /dev/nvidia4:/dev/nvidia4 \\\n       --device /dev/nvidia5:/dev/nvidia5 \\\n       --device /dev/nvidia6:/dev/nvidia6 \\\n       --device /dev/nvidia7:/dev/nvidia7 \\\n"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| cloud\_config | Rendered cloud config from template |
| startup\_script | Rendered startup script |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
