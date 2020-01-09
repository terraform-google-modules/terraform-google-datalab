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
  datalab_disk_name = "${var.name}-pd"

  datalab_cpu_docker_image = "gcr.io/cloud-datalab/datalab:latest"
  datalab_gpu_docker_image = "gcr.io/cloud-datalab/datalab-gpu:latest"
  datalab_docker_image     = var.datalab_docker_image == null ? (var.gpu_instance ? local.datalab_gpu_docker_image : local.datalab_cpu_docker_image) : var.datalab_docker_image

  cloud_config        = var.gpu_instance ? "gpu_cloud_config.tpl" : "default_cloud_config.tpl"
  on_host_maintenance = var.gpu_instance ? "TERMINATE" : "MIGRATE"
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
  cloud_config              = local.cloud_config
  append_to_startup_script  = var.append_to_startup_script
  datalab_disk_name         = local.datalab_disk_name
  datalab_enable_swap       = var.datalab_enable_swap
  datalab_docker_image      = local.datalab_docker_image
  datalab_enable_backup     = var.datalab_enable_backup
  datalab_console_log_level = var.datalab_console_log_level
  datalab_user_email        = var.datalab_user_email
  datalab_idle_timeout      = var.datalab_idle_timeout
  fluentd_docker_image      = var.fluentd_docker_image
  gpu_count                 = var.gpu_count
}

/***********************************************
  Create GCE instance
 ***********************************************/
resource "google_compute_instance" "main" {
  name                      = var.name
  project                   = var.project_id
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true

  tags = ["datalab"]

  labels = merge(var.labels, {
    role    = "datalab"
    use_gpu = var.gpu_instance
  }, var.gpu_instance ? { gpu_count = var.gpu_count } : {})

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size  = var.boot_disk_size_gb
    }
  }

  attached_disk {
    source      = var.create_disk ? google_compute_disk.main.0.name : var.existing_disk_name
    device_name = local.datalab_disk_name
  }

  network_interface {
    subnetwork = var.subnet_name
  }

  metadata = {
    enable-oslogin = "TRUE"
    for-user       = var.datalab_user_email
    user-data      = module.template_files.cloud_config
  }

  metadata_startup_script = module.template_files.startup_script

  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = true
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = local.on_host_maintenance
    preemptible         = false
  }

  dynamic "guest_accelerator" {
    for_each = var.gpu_instance ? [true] : []
    content {
      count = var.gpu_count
      type  = var.gpu_type
    }
  }
}

/******************************************
  Create the persistent data disk
 *****************************************/
resource "google_compute_disk" "main" {
  name    = local.datalab_disk_name
  project = var.project_id
  count   = var.create_disk ? 1 : 0
  type    = "pd-ssd"
  size    = var.persistent_disk_size_gb
  zone    = var.zone
}
