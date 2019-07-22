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
  description = "The project ID to deploy to"
}

variable "bucket_name" {
  description = "The name of the bucket to create"
}

variable "name" {
  type = "string"
}

variable "zone" {
  type = "string"
}

variable "network_name" {
  type = "string"
}

variable "subnet_name" {
  type = "string"
}

variable "machine_type" {
  type    = "string"
  default = "n1-standard-2"
}

variable "allow_stopping_for_update" {
  type    = "string"
  default = "true"
}

variable "gpu_count" {
  type    = "string"
  default = 0
}

variable "gpu_type" {
  type    = "string"
  default = "nvidia-tesla-k80"
}

variable "service_account" {
  type    = "string"
  default = ""
}

variable "boot_disk_size_gb" {
  type    = "string"
  default = "20"
}

variable "persistent_disk_size_gb" {
  type    = "string"
  default = "200"
}

variable "existing_disk_name" {
  type    = "string"
  default = ""
}

variable "datalab_docker_image" {
  type    = "string"
  default = "gcr.io/cloud-datalab/datalab:latest"
}

variable "datalab_gpu_docker_image" {
  default = "gcr.io/cloud-datalab/datalab-gpu:latest"
}

variable "datalab_enable_swap" {
  type    = "string"
  default = "true"
}

variable "datalab_enable_backup" {
  type    = "string"
  default = "true"
}

variable "datalab_console_log_level" {
  type    = "string"
  default = "warn"
}

variable "datalab_user_email" {
  type = "string"
}

variable "datalab_idle_timeout" {
  type    = "string"
  default = "90m"
}

variable "fluentd_docker_image" {
  type    = "string"
  default = "gcr.io/google-containers/fluentd-gcp:2.0.17"
}

variable "systemctl_gpu" {
  default = <<EOT
- systemctl enable cos-gpu-installer.service
- systemctl start cos-gpu-installer.service
EOT
}

variable gpu_device_map {
  default = {
    gpu_device_0 = ""

    gpu_device_1 = <<EOT
       --device /dev/nvidia0:/dev/nvidia0 \
       EOT

    gpu_device_2 = <<EOT
       --device /dev/nvidia0:/dev/nvidia0 \
       --device /dev/nvidia1:/dev/nvidia1 \
       EOT

    gpu_device_4 = <<EOT
       --device /dev/nvidia0:/dev/nvidia0 \
       --device /dev/nvidia1:/dev/nvidia1 \
       --device /dev/nvidia2:/dev/nvidia2 \
       --device /dev/nvidia3:/dev/nvidia3 \
       EOT

    gpu_device_8 = <<EOT
       --device /dev/nvidia0:/dev/nvidia0 \
       --device /dev/nvidia1:/dev/nvidia1 \
       --device /dev/nvidia2:/dev/nvidia2 \
       --device /dev/nvidia3:/dev/nvidia3 \
       --device /dev/nvidia4:/dev/nvidia4 \
       --device /dev/nvidia5:/dev/nvidia5 \
       --device /dev/nvidia6:/dev/nvidia6 \
       --device /dev/nvidia7:/dev/nvidia7 \
       EOT
  }
}
