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

/******************************************
  Firewall rule to allow tunnel-through-iap
 *****************************************/
resource "google_compute_firewall" "iap" {
  count          = var.create_rule ? 1 : 0
  provider       = google-beta
  name           = "${var.network_name}-allow-iap"
  project        = var.project_id
  network        = var.network_name
  description    = var.firewall_description
  direction      = "INGRESS"
  disabled       = false
  priority       = "65534"
  enable_logging = true
  source_ranges  = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = var.ports
  }

  target_tags = var.target_tags
}
