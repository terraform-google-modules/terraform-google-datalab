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

module "datalab_instance" {
  source = "../instance"

  project_id                = var.project_id
  name                      = var.name
  zone                      = var.zone
  network_name              = var.network_name
  subnet_name               = var.subnet_name
  service_account           = var.service_account
  machine_type              = var.machine_type
  boot_disk_size_gb         = var.boot_disk_size_gb
  persistent_disk_size_gb   = var.persistent_disk_size_gb
  create_disk               = var.create_disk
  existing_disk_name        = var.existing_disk_name
  datalab_enable_swap       = var.datalab_enable_swap
  datalab_enable_backup     = var.datalab_enable_backup
  datalab_console_log_level = var.datalab_console_log_level
  datalab_user_email        = var.datalab_user_email
  datalab_idle_timeout      = var.datalab_idle_timeout
  fluentd_docker_image      = var.fluentd_docker_image
  datalab_docker_image      = var.datalab_docker_image
  append_to_startup_script  = var.append_to_startup_script
  create_fw_rule            = var.create_fw_rule
  labels                    = var.labels
}
