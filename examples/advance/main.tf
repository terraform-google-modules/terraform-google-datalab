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

provider "google" {
  version = "~> 3.53"
}

locals {
  network_name = "${var.network_name}-advance"
  subnet_name  = "${local.network_name}-subnet"
  subnet_ip    = "10.10.10.0/24"
}

/******************************************
  Create VPC
 *****************************************/
module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 3.0"
  project_id   = var.project_id
  network_name = local.network_name

  subnets = [
    {
      subnet_name   = local.subnet_name
      subnet_ip     = local.subnet_ip
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${local.subnet_name}" = []
  }
}

/******************************************
  Adding Cloud Router
 *****************************************/

resource "google_compute_router" "main" {
  name    = "${module.vpc.network_name}-router"
  project = var.project_id
  region  = var.region
  network = module.vpc.network_self_link

  bgp {
    asn = 64514
  }
}

/******************************************
  Adding Cloud NAT
 *****************************************/
resource "google_compute_router_nat" "main" {
  name                               = "${module.vpc.network_name}-nat"
  router                             = google_compute_router.main.name
  project                            = var.project_id
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = module.vpc.subnets_self_links[0]
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}

/******************************************
  Create Service account
 *****************************************/
resource "google_service_account" "main" {
  project      = var.project_id
  account_id   = "datalab"
  display_name = "datalab"
}

resource "google_project_iam_member" "main" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.main.email}"
}

/******************************************
  Create a GPU Datalab instance
 *****************************************/
module "datalab" {
  source                    = "../../modules/instance"
  project_id                = var.project_id
  name                      = "${var.name}-gpu"
  zone                      = var.zone
  datalab_user_email        = var.datalab_user_email
  network_name              = module.vpc.network_name
  subnet_name               = module.vpc.subnets_self_links[0]
  service_account           = google_service_account.main.email
  machine_type              = var.machine_type
  boot_disk_size_gb         = var.boot_disk_size_gb
  create_disk               = true
  persistent_disk_size_gb   = var.persistent_disk_size_gb
  gpu_instance              = true
  gpu_type                  = var.gpu_type
  gpu_count                 = var.gpu_count
  datalab_docker_image      = var.datalab_gpu_docker_image
  fluentd_docker_image      = var.fluentd_docker_image
  datalab_enable_swap       = var.datalab_enable_swap
  datalab_enable_backup     = var.datalab_enable_backup
  datalab_console_log_level = var.datalab_console_log_level
  datalab_idle_timeout      = var.datalab_idle_timeout
  labels                    = var.labels
  enable_secure_boot        = var.enable_secure_boot
}
