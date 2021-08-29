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

variable "network_name" {
  description = "The network the Datalab instance will be in"
}

variable "firewall_description" {
  description = "Description for firewall rule"
  default     = "Allow IAP access"
}

variable "target_tags" {
  description = "A list of instance tags indicating sets of instances located in the network that may make network connections as specified"
  type        = list(any)
}

variable "ports" {
  description = "A list of ports to which this rule applies"
  type        = list(any)
}

variable "create_rule" {
  default     = true
  description = "Flag to create or skip Firewall rule creation"
  type        = bool
}

