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

variable "cloud_config" {
  description = "Name of the cloud config template to use"
}

variable "datalab_disk_name" {
  description = "Name of the persistent disk to mount to the Datalab instance"
}

variable "datalab_docker_image" {
  description = "Datalab docker image to use"
  default     = "gcr.io/cloud-datalab/datalab:latest"
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

variable "gpu_count" {
  description = "Number of GPUs for the Datalab instance. Valid values are: 0, 1, 2, 4, 8"
  type        = number
  default     = 0
}

variable gpu_device_map {
  description = "Cloud config to map the number of gpu devices"
  type        = map
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

variable "append_to_startup_script" {
  default     = null
  description = "Full path to file with content to be added to the startup script." 
  type        = string
}
