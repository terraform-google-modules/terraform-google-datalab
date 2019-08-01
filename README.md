# Google Datalab Terraform Module

Use [Cloud Datalab](https://cloud.google.com/datalab/) to easily explore, visualize, analyze, and transform data using familiar languages, such as Python and SQL, interactively.


This module allows you to create opinionated Google Cloud Datalab instances.

The resources/services/activations/deletions that this module will create/trigger are:
- Create a firewall rule to allow [Cloud IAP for TCP forwarding](https://cloud.google.com/iap/docs/using-tcp-forwarding)
- Create a private GCE Datalab instance with an option to have GPUs attached.

## Compatibility

This module is meant for use with Terraform 0.12.

## Usage

Basic usage of this module is as follows:

```hcl
module "datalab" {
  source             = "terraform-google-modules/datalab/google"
  version            = "~> 0.1"
  project_id         = "<PROJECT ID>"
  zone               = "us-central1-c"
  datalab_user_email = "<DATALAB USER EMAIL>
  network_name       = "datalab-network"
  subnet_name        = "datalab-subnetwork"
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| boot\_disk\_size\_gb | The boot disk size in gb for the Datalab instance | string | `"20"` | no |
| datalab\_console\_log\_level | The log level for which log entries from the Datalab instance will be written to StackDriver logging. Valid choices: (trace,debug,info,warn,error,fatal) | string | `"warn"` | no |
| datalab\_docker\_image | Datalab docker image to use | string | `"gcr.io/cloud-datalab/datalab:latest"` | no |
| datalab\_enable\_backup | Automatically backup the disk contents to Cloud Storage | string | `"true"` | no |
| datalab\_enable\_swap | Enable swap on the Datalab instance | string | `"true"` | no |
| datalab\_gpu\_docker\_image | Datalab GPU docker image to use | string | `"gcr.io/cloud-datalab/datalab-gpu:latest"` | no |
| datalab\_idle\_timeout | Interval after which an idle Datalab instance will shut down. You can specify a mix of days, hours, minutes and seconds using those names or d, h, m and s, for example 1h 30m. Specify 0s to disable | string | `"60m"` | no |
| datalab\_user\_email | Create the Datalab instance on behalf of the specified user | string | n/a | yes |
| existing\_disk\_name | Name of an existing persistent disk you want to use | string | `""` | no |
| fluentd\_docker\_image | Fluentd docker image to use | string | `"gcr.io/google-containers/fluentd-gcp:2.0.17"` | no |
| gpu\_count | Number of GPUs for the Datalab instance. Valid values are: 0, 1, 2, 4, 8 | string | `"0"` | no |
| gpu\_type | The GPU type for the Datalab instance | string | `"nvidia-tesla-k80"` | no |
| machine\_type | The machine type for the Datalab instance | string | `"n1-standard-2"` | no |
| name | The name of the Datalab instance | string | `"datalab"` | no |
| network\_name | The network the Datalab instance will be in | string | n/a | yes |
| persistent\_disk\_size\_gb | The persistent disk size in gb for the Datalab instance | string | `"200"` | no |
| project\_id | The project ID used for the Datalab instance | string | n/a | yes |
| service\_account | The service account attached to the Datalab instance. If empty the default Google Compute Engine service account is used | string | `""` | no |
| subnet\_name | The subnet the Datalab instance will be in | string | n/a | yes |
| systemctl\_gpu |  | string | `"- systemctl enable cos-gpu-installer.service\n- systemctl start cos-gpu-installer.service\n"` | no |
| zone | The zone the Datalab instance will be deployed to | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| disk\_name | The name of the persistent disk |
| disk\_size | The size of the persistent disk |
| firewall\_name | The name of the firewall rule |
| instance\_name | The instance name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.12
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.0

### Service Account

A service account with the following minimum roles must be used to provision
the resources of this module:

- Compute Instance Admin: `roles/compute.instanceAdmin` (create instance)
- Compute Security Admin: `roles/compute.securityAdmin` (create firewall rule)
- Service Account User: `roles/iam.serviceAccountUser` (access service account)

If using the examples you will need these additional roles.
- Compute Network Admin: `roles/compute.networkAdmin` (create VPC)

Advance Example
- Service Account Admin: `roles/iam.serviceAccountAdmin` (create service account)
- Projects IAM Admin: `roles/resourcemanager.projectIamAdmin` (set IAM policy on project)

### Service Account for instance

The service account for the datalab instances will need the permission `compute.instances.stop` in order to allow the idle timeout option to shutdown the instance.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Compute Engine API : `compute.googleapis.com`
- Identity and Access Management API : `iam.googleapis.com`
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

# Access the Cloud Datalab UI
Setup tunnel to the Datalab UI
```
gcloud beta compute start-iap-tunnel INSTANCE_NAME 8080 \
  --project PROJECT \
  --zone ZONE \
  --local-host-port=localhost:8080
```
Using your browser go to http://localhost:8080

# GPU instances
Not all GPU types are supported in all zones. Go here to check which GPU type and zones are supported https://cloud.google.com/compute/docs/gpus/


The Datalab GPU instance will take a few more minutes to come up since it needs to install the NVIDIA Accelerated Graphics Driver

To verify that the drivers are installed correctly and the instance has the correct number of GPUs run:
`/var/lib/nvidia/bin/nvidia-smi`
