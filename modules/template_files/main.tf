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
  startup_script_content = var.append_to_startup_script == null ? data.template_file.startup_script.rendered : "${data.template_file.startup_script.rendered}\n\n${data.local_file.additional_startup_script[0].content}"
}

/***********************************************
  Template for the startup script
 ***********************************************/
data "google_secret_manager_secret_version" "docker_registry_user" {
  count    = var.private_datalab_registry_info == null ? 0 : 1
  provider = google-beta
  project  = var.private_datalab_registry_info.secret_project_id
  secret   = var.private_datalab_registry_info.user_secret_id
}

data "google_secret_manager_secret_version" "docker_registry_password" {
  count    = var.private_datalab_registry_info == null ? 0 : 1
  provider = google-beta
  project  = var.private_datalab_registry_info.secret_project_id
  secret   = var.private_datalab_registry_info.password_secret_id
}

locals {
  docker_registry = var.private_datalab_registry_info == null ? "" : var.private_datalab_registry_info.docker_registry_url
  docker_user     = var.private_datalab_registry_info == null ? "" : data.google_secret_manager_secret_version.docker_registry_user[0].secret_data
  docker_password = var.private_datalab_registry_info == null ? "" : data.google_secret_manager_secret_version.docker_registry_password[0].secret_data
}

data "template_file" "startup_script" {
  template = "${file("${path.module}/templates/startup_script.tpl")}"

  vars = {
    datalab_docker_image = var.datalab_docker_image
    disk_name            = var.datalab_disk_name
    datalab_enable_swap  = var.datalab_enable_swap
    docker_registry      = local.docker_registry
    docker_user          = local.docker_user
    docker_password      = local.docker_password
  }
}

/***********************************************
  Additiounal content for the startup script
 ***********************************************/
data "local_file" "additional_startup_script" {
  count    = var.append_to_startup_script == null ? 0 : 1
  filename = var.append_to_startup_script
}

/***********************************************
  Main cloud config template
 ***********************************************/
data "template_file" "cloud_config" {
  template = "${file("${path.module}/templates/${var.cloud_config}")}"

  vars = {
    datalab_docker_image      = var.datalab_docker_image
    datalab_enable_backup     = var.datalab_enable_backup
    datalab_console_log_level = var.datalab_console_log_level
    datalab_user_email        = var.datalab_user_email
    datalab_idle_timeout      = var.datalab_idle_timeout
    fluentd_docker_image      = var.fluentd_docker_image
    gpu_device                = var.gpu_device_map["gpu_device_${var.gpu_count}"]
  }
}
