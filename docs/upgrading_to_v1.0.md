# Upgrading to v1.0

The v1.0 release of *datalab* is a backwards incompatible release.

The individual `default_instance` and `gpu_instance` submodules were removed in favor of a generic `instance` submodule.

## Migration Instructions

The new `instance` submodule is compatible with both the old `default` and `gpu` instance modules and will not require the re-creation of any resources.

### Migrating From a Default Instance

Simply change the source path to the new module location and version.

```hcl
module "datalab" {
  source             = "terraform-google-modules/datalab/google//modules/instance"
  version            = "~> 1.0"
  ...
```

All other variables and defaults remain the same.

After `terraform init` a `terraform plan` should show no changes.

### Migrating GPU Instance

Similar to the default instance, update the location and version to the new module.

Also set the new variable `gpu_instance = true`

```hcl
module "datalab" {
  source       = "terraform-google-modules/datalab/google//modules/instance"
  version      = "~> 1.0"
  gpu_instance = true
  ...

```

All other variables and defaults remain the same.

After `terraform init` a `terraform plan` should show no changes.
