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

variable "project_id" {
  description = "The project ID used for the Datalab instance"
}

variable "name" {
  description = "The name of the Datalab instance"
  default     = "datalab"
}

variable "zone" {
  description = "The zone the Datalab instance will be deployed to"
}

variable "network_name" {
  description = "The network the Datalab instance will be in"
}

variable "subnet_name" {
  description = "The subnet the Datalab instance will be in"
}

variable "service_account" {
  description = "The service account attached to the Datalab instance. If empty the default Google Compute Engine service account is used"
  default     = null
}

variable "machine_type" {
  description = "The machine type for the Datalab instance"
  default     = "n1-standard-2"
}

variable "boot_disk_size_gb" {
  description = "The boot disk size in gb for the Datalab instance"
  default     = 20
}

variable "persistent_disk_size_gb" {
  description = "The persistent disk size in gb for the Datalab instance"
  type        = number
  default     = 200
}

variable "create_disk" {
  description = "Create a persistent data disk"
  type        = bool
  default     = true
}

variable "existing_disk_name" {
  description = "Name of an existing persistent disk you want to use"
  default     = null
}

variable "datalab_enable_swap" {
  description = "Enable swap on the Datalab instance"
  type        = bool
  default     = true
}

variable "datalab_enable_backup" {
  description = "Automatically backup the disk contents to Cloud Storage"
  type        = bool
  default     = true
}

variable "datalab_console_log_level" {
  description = "The log level for which log entries from the Datalab instance will be written to StackDriver logging. Valid choices: (trace,debug,info,warn,error,fatal)"
  default     = "warn"
}

variable "datalab_user_email" {
  description = "Create the Datalab instance on behalf of the specified user"
}

variable "datalab_idle_timeout" {
  description = "Interval after which an idle Datalab instance will shut down. You can specify a mix of days, hours, minutes and seconds using those names or d, h, m and s, for example 1h 30m. Specify 0s to disable"
  default     = "60m"
}

variable "fluentd_docker_image" {
  description = "Fluentd docker image to use"
  default     = "gcr.io/google-containers/fluentd-gcp:2.0.17"
}

variable "datalab_docker_image" {
  description = "Datalab docker image to use"
  default     = "gcr.io/cloud-datalab/datalab-gpu:latest"
}

variable "gpu_count" {
  description = "Number of GPUs for the Datalab instance. Valid values are: 0, 1, 2, 4, 8"
  default     = 0
}

variable "gpu_type" {
  description = "The GPU type for the Datalab instance"
  default     = "nvidia-tesla-k80"
}

variable "create_fw_rule" {
  default     = true
  description = "Flag to create Firewall rule for SSH access to Datalab"
  type        = bool
}

