/**
 * Copyright 2018 Google LLC
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
  description = "The ID of the project in which to provision resources."
}

variable "name" {
  description = "Instance name"
  default     = "datalab"
}

variable "region" {
  default = "us-central1"
}

variable "network_name" {
  description = "The name of the VPC network being created"
  default     = "datalab-network"
}

variable "zone" {
  default = "us-central1-c"
}

variable "service_account" {
  default = ""
}

variable "machine_type" {
  default = "n1-standard-2"
}

variable "boot_disk_size_gb" {
  default = "20"
}

variable "persistent_disk_size_gb" {
  default = "200"
}

variable "gpu_count" {
  description = "Valid values are: 0, 1, 2, 4, 8"
  default     = 0
}

variable "gpu_type" {
  default = "nvidia-tesla-k80"
}

variable "datalab_docker_image" {
  default = "gcr.io/cloud-datalab/datalab:latest"
}

variable "datalab_gpu_docker_image" {
  default = "gcr.io/cloud-datalab/datalab-gpu:latest"
}

variable "datalab_enable_swap" {
  description = "Enable swap on the datalab instance"
  default     = "true"
}

variable "datalab_enable_backup" {
  description = "Automatically backup the disk contents to Cloud Storage"
  default     = "true"
}

variable "datalab_console_log_level" {
  description = <<EOF
The log level for which log entries from the Datalab instance will be written
to StackDriver logging. Valid choices: (trace,debug,info,warn,error,fatal)
EOF

  default = "warn"
}

variable "datalab_user_email" {
  description = "Create the datalab instance on behalf of the specified user"
}

variable "datalab_idle_timeout" {
  description = <<EOF
Interval after which an idle Datalab instance will shut down.
You can specify a mix of days, hours, minutes and seconds using those names
or d, h, m and s, for example 1h 30m. Specify 0s to disable.
EOF

  default = "60m"
}

variable "fluentd_docker_image" {
  default = "gcr.io/google-containers/fluentd-gcp:2.0.17"
}
