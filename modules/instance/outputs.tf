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

output "firewall_name" {
  description = "The name of the firewall rule"
  value       = module.iap_firewall.firewall_name
}

output "disk_name" {
  description = "The name of the persistent disk"
  value       = google_compute_disk.main[0].name
}

output "disk_size" {
  description = "The size of the persistent disk"
  value       = google_compute_disk.main[0].size
}

output "instance_name" {
  description = "The instance name"
  value       = google_compute_instance.main.name
}

output "labels" {
  description = "A map of key/value label pairs to assigned to the instance."
  value       = google_compute_instance.main.labels
}
