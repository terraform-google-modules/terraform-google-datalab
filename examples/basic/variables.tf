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

variable "region" {
  description = "The region the network will be created in"
  default     = "us-central1"
}

variable "zone" {
  description = "The zone the Datalab instance will be deployed to"
  default     = "us-central1-c"
}

variable "network_name" {
  description = "The name of the VPC network being created"
  default     = "datalab-network"
}

variable "service_account" {
  description = "The service account attached to the Datalab instance. If empty the default Google Compute Engine service account is used"
  default     = null
}

variable "datalab_user_email" {
  description = "Create the Datalab instance on behalf of the specified user"
}

variable "create_fw_rule" {
  default     = true
  description = "Flag to create Firewall rule for SSH access to Datalab"
  type        = bool
}

variable "labels" {
  description = "A map of key/value label pairs to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "enable_secure_boot" {
  type        = bool
  description = "Verify the digital signature of all boot components, and halt the boot process if signature verification fails"
  default     = false
}
