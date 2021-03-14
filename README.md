# Google Datalab Terraform Module

Use [Cloud Datalab](https://cloud.google.com/datalab/) to easily explore, visualize, analyze, and transform data using familiar languages, such as Python and SQL, interactively.

## Compatibility
This module is meant for use with Terraform 0.13. If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-13.html) and need a Terraform
0.12.x-compatible version of this module, the last released version
intended for Terraform 0.12.x is [v1.0.0](https://registry.terraform.io/modules/terraform-google-modules/-datalab/google/v1.0.0).

## Usage

Basic usage of this module is as follows:

```hcl
module "datalab" {
  source             = "terraform-google-modules/datalab/google//modules/instance"
  version            = "~> 1.0"
  project_id         = "<PROJECT ID>"
  zone               = "us-central1-c"
  datalab_user_email = "<DATALAB USER EMAIL>
  network_name       = "datalab-network"
  subnet_name        = "datalab-subnetwork"
}
```

Functional examples are included in the
[examples](./examples/) directory.

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
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
