/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  datalab_name       = { for u in var.datalab_user_emails : u => join("",[var.prefix, split("@",u)[0]])}
  datalab_disk_names = { for u in var.datalab_user_emails : u => "${local.datalab_name[u]}-pd"}
}

/******************************************
  Firewall rule to allow tunnel-through-iap
 *****************************************/
module "iap_firewall" {
  source               = "../iap_firewall"
  create_rule          = var.create_fw_rule
  project_id           = var.project_id
  network_name         = var.network_name
  firewall_description = "Allow SSH and web UI IAP tunnel to Datalab instance"
  target_tags          = ["datalab"]
  ports                = ["22", "8080"]
}

/***********************************************
  Render start up and cloud config scripts from templates
 ***********************************************/
module "template_files" {
  source                    = "../template_files"
  cloud_config              = "default_cloud_config.tpl"
  append_to_startup_script  = var.append_to_startup_script
  datalab_disk_names        = local.datalab_disk_names
  datalab_enable_swap       = var.datalab_enable_swap
  datalab_docker_image      = var.datalab_docker_image
  datalab_enable_backup     = var.datalab_enable_backup
  datalab_console_log_level = var.datalab_console_log_level
  datalab_user_emails       = var.datalab_user_emails
  datalab_idle_timeout      = var.datalab_idle_timeout
  fluentd_docker_image      = var.fluentd_docker_image
}

/***********************************************
  Create GCE instance
 ***********************************************/
resource "google_compute_instance" "main" {
  for_each                  = var.datalab_user_emails
  name                      = local.datalab_name[each.key]
  project                   = var.project_id
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true

  tags = ["datalab"]

  labels = {
    role    = "datalab"
    use_gpu = false
  }

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size  = var.boot_disk_size_gb
    }
  }

  attached_disk {
    source      = var.create_disk ? google_compute_disk.main[each.key].name : var.existing_disk_names[each.key]
    device_name = var.create_disk ? google_compute_disk.main[each.key].name : var.existing_disk_names[each.key]
  }

  network_interface {
    subnetwork = var.subnet_name
  }

  metadata = {
    enable-oslogin = "TRUE"
    for-user       = each.key
    user-data      = module.template_files.cloud_config[each.key]
  }

  metadata_startup_script = module.template_files.startup_script[each.key]

  service_account {
    email  = var.create_service_account ? google_service_account.datalab_service_account[each.key].email : var.service_accounts[each.key]
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }
}

/******************************************
  Create the persistent data disk
 *****************************************/
resource "google_compute_disk" "main" {
  for_each = var.create_disk ? var.datalab_user_emails : toset({})
  name     = local.datalab_disk_names[each.key]
  project  = var.project_id
  type     = "pd-ssd"
  size     = var.persistent_disk_size_gb
  zone     = var.zone
}

/******************************************
  Create the service account
 *****************************************/
resource "google_service_account" "datalab_service_account" {
    for_each = var.create_service_account ? var.datalab_user_emails : toset([])
    account_id = local.datalab_name[each.key]
    project = var.project_id
}
