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

output "bucket_name" {
  value = google_storage_bucket.main.name
}

output "zone" {
  value = var.zone
}

output "firewall_name" {
  value = google_compute_firewall.main.name
}

output "disk_name" {
  value = google_compute_disk.main.0.name
}

output "disk_size" {
  value = var.persistent_disk_size_gb
}

output "instance_name" {
  value = google_compute_instance.main.name
}
