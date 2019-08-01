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

terraform {
  required_version = "~> 0.12.0"
}

locals {
  datalab_docker_image = var.gpu_count == "0" ? var.datalab_docker_image : var.datalab_gpu_docker_image
  datalab_disk_name    = "${var.name}-pd"
}

/******************************************
  Firewall rule to allow tunnel-through-iap
 *****************************************/
resource "google_compute_firewall" "main" {
  provider       = "google-beta"
  name           = "${var.network_name}-allow-iap"
  project        = "${var.project_id}"
  network        = "${var.network_name}"
  description    = "Allow SSH and web UI IAP tunnel to Datalab instance"
  direction      = "INGRESS"
  disabled       = false
  priority       = "65534"
  enable_logging = true
  source_ranges  = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }

  target_tags = ["datalab"]
}

/***********************************************
  Template for the startup script
 ***********************************************/
data "template_file" "startup_script" {
  template = "${file("${path.module}/templates/startup_script.tpl")}"

  vars = {
    datalab_docker_image = local.datalab_docker_image
    disk_name            = "${var.name}-pd"
    datalab_enable_swap  = var.datalab_enable_swap
  }
}

/***********************************************
  Partial template that goes into cloud config for default instances
 ***********************************************/
data "template_file" "datalab_partial" {
  template = "${file("${path.module}/templates/datalab_partial.tpl")}"

  vars = {
    datalab_docker_image      = local.datalab_docker_image
    datalab_enable_backup     = var.datalab_enable_backup
    datalab_console_log_level = var.datalab_console_log_level
    datalab_user_email        = var.datalab_user_email
    datalab_idle_timeout      = var.datalab_idle_timeout
  }
}

/***********************************************
  Partial template that goes into cloud config for GPU instances
 ***********************************************/
data "template_file" "datalab_gpu_partial" {
  template = "${file("${path.module}/templates/datalab_gpu_partial.tpl")}"

  vars = {
    datalab_docker_image      = local.datalab_docker_image
    datalab_enable_backup     = var.datalab_enable_backup
    datalab_console_log_level = var.datalab_console_log_level
    datalab_user_email        = var.datalab_user_email
    datalab_idle_timeout      = var.datalab_idle_timeout
    gpu_device                = var.gpu_device_map["gpu_device_${var.gpu_count}"]
  }
}

/***********************************************
  Main cloud config template
 ***********************************************/
data "template_file" "cloud_config" {
  template = "${file("${path.module}/templates/cloud_config.tpl")}"

  vars = {
    datalab_partial     = var.gpu_count == "0" ? data.template_file.datalab_partial.rendered : ""
    datalab_gpu_partial = var.gpu_count == "0" ? "" : data.template_file.datalab_gpu_partial.rendered

    fluentd_docker_image = var.fluentd_docker_image
    systemctl_gpu        = var.gpu_count == "0" ? "" : var.systemctl_gpu
  }
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

  labels = {
    role      = "datalab"
    use_gpu   = var.gpu_count == "0" ? "false" : "true"
    gpu_count = var.gpu_count
  }

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size  = var.boot_disk_size_gb
    }
  }

  attached_disk {
    source      = var.existing_disk_name == "" ? google_compute_disk.main.0.name : var.existing_disk_name
    device_name = local.datalab_disk_name
  }

  network_interface {
    subnetwork = var.subnet_name
  }

  metadata = {
    enable-oslogin = "TRUE"
    for-user       = var.datalab_user_email
    user-data      = data.template_file.cloud_config.rendered
  }

  metadata_startup_script = data.template_file.startup_script.rendered

  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = var.gpu_count == "0" ? "MIGRATE" : "TERMINATE"
    preemptible         = false
  }

  guest_accelerator {
    count = var.gpu_count == "0" ? 0 : var.gpu_count
    type  = var.gpu_type
  }
}

/******************************************
  Create the persistent data disk
  Does not create a new disk if an existing_disk_name is set
 *****************************************/
resource "google_compute_disk" "main" {
  name    = local.datalab_disk_name
  project = var.project_id
  count   = var.existing_disk_name == "" ? 1 : 0
  type    = "pd-ssd"
  size    = var.persistent_disk_size_gb
  zone    = var.zone
}
