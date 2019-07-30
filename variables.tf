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
  description = "The project ID used for the Datalab instance"
}

variable "name" {
  description = "The name of the Datalab instance"
  type        = "string"
}

variable "zone" {
  description = "The zone the Datalab instance will be deployed to"
  type        = "string"
}

variable "network_name" {
  description = "The network the Datalab instance will be in"
  type        = "string"
}

variable "subnet_name" {
  description = "The subnet the Datalab instance will be in"
  type        = "string"
}

variable "service_account" {
  description = "The service account attached to the Datalab instance"
  type        = "string"
  default     = ""
}

variable "machine_type" {
  description = "The machine type for the Datalab instance"
  type        = "string"
  default     = "n1-standard-2"
}

variable "boot_disk_size_gb" {
  description = "The boot disk size in gb for the Datalab instance"
  type        = "string"
  default     = "20"
}

variable "persistent_disk_size_gb" {
  description = "The persistent disk size in gb for the Datalab instance"
  type        = "string"
  default     = "200"
}

variable "existing_disk_name" {
  description = "Name of an existing persistent disk you want to use"
  type        = "string"
  default     = ""
}

variable "gpu_count" {
  description = "Number of GPUs for the Datalab instance. Valid values are: 0, 1, 2, 4, 8"
  type        = "string"
  default     = 0
}

variable "gpu_type" {
  description = "The GPU type for the Datalab instance"
  type        = "string"
  default     = "nvidia-tesla-k80"
}

variable "datalab_docker_image" {
  description = "Datalab docker image to use"
  type        = "string"
  default     = "gcr.io/cloud-datalab/datalab:latest"
}

variable "datalab_gpu_docker_image" {
  description = "Datalab GPU docker image to use"
  default     = "gcr.io/cloud-datalab/datalab-gpu:latest"
}

variable "datalab_enable_swap" {
  description = "Enable swap on the Datalab instance"
  type        = "string"
  default     = "true"
}

variable "datalab_enable_backup" {
  description = "Automatically backup the disk contents to Cloud Storage"
  type        = "string"
  default     = "true"
}

variable "datalab_console_log_level" {
  description = <<EOF
The log level for which log entries from the Datalab instance will be written
to StackDriver logging. Valid choices: (trace,debug,info,warn,error,fatal)
EOF
  type = "string"
  default = "warn"
}

variable "datalab_user_email" {
  description = "Create the Datalab instance on behalf of the specified user"
  type = "string"
}

variable "datalab_idle_timeout" {
  description = <<EOF
Interval after which an idle Datalab instance will shut down.
You can specify a mix of days, hours, minutes and seconds using those names
or d, h, m and s, for example 1h 30m. Specify 0s to disable.
EOF
  type    = "string"
  default = "90m"
}

variable "fluentd_docker_image" {
  description = "Fluentd docker image to use"
  type        = "string"
  default     = "gcr.io/google-containers/fluentd-gcp:2.0.17"
}

variable "systemctl_gpu" {
  default = <<EOF
- systemctl enable cos-gpu-installer.service
- systemctl start cos-gpu-installer.service
EOF
}

variable gpu_device_map {
  default = {
    gpu_device_0 = ""

    gpu_device_1 = <<EOF
       --device /dev/nvidia0:/dev/nvidia0 \
       EOF

  gpu_device_2 = <<EOF
       --device /dev/nvidia0:/dev/nvidia0 \
       --device /dev/nvidia1:/dev/nvidia1 \
       EOF

  gpu_device_4 = <<EOF
       --device /dev/nvidia0:/dev/nvidia0 \
       --device /dev/nvidia1:/dev/nvidia1 \
       --device /dev/nvidia2:/dev/nvidia2 \
       --device /dev/nvidia3:/dev/nvidia3 \
       EOF

  gpu_device_8 = <<EOF
       --device /dev/nvidia0:/dev/nvidia0 \
       --device /dev/nvidia1:/dev/nvidia1 \
       --device /dev/nvidia2:/dev/nvidia2 \
       --device /dev/nvidia3:/dev/nvidia3 \
       --device /dev/nvidia4:/dev/nvidia4 \
       --device /dev/nvidia5:/dev/nvidia5 \
       --device /dev/nvidia6:/dev/nvidia6 \
       --device /dev/nvidia7:/dev/nvidia7 \
       EOF
  }
}
