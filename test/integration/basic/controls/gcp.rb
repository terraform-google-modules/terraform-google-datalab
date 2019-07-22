# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute('project_id')
region = attribute('region')
zone = attribute('zone')
router_name = attribute('router_name')
nat_name = attribute('nat_name')
network_name = attribute('network_name')
subnet_name = attribute('subnet_name')
firewall_name = attribute('firewall_name')
disk_name = attribute('disk_name')
disk_size = attribute('disk_size')
instance_name = attribute('instance_name')

control "gcp" do
  title "GCP Resources"

  describe google_storage_bucket(name: attribute("bucket_name")) do
    it { should exist }
  end

  describe google_compute_router(project: "#{project_id}", region: "#{region}", name: "#{router_name}") do
    it { should exist }
    its('bgp.asn') { should eq (64514) }
    its('bgp.advertise_mode') { should eq 'DEFAULT' }
    its('network') { should match "#{network_name}" }
    its('region') { should match "#{region}" }
    end

  describe google_compute_firewall(project: "#{project_id}", name: "#{firewall_name}") do
    it { should exist }
    its('name') { should eq "#{firewall_name}" }
    its('direction') { should eq "INGRESS" }
    it { should_not allow_ip_ranges ["0.0.0.0/0"] }
    it { should allow_ip_ranges ["35.235.240.0/20"] }
    it { should allow_port_protocol("8080", "tcp") }
    it { should allow_port_protocol("22", "tcp") }
    it { should allow_target_tags ["datalab"] }
  end

  describe google_compute_disk(project: "#{project_id}", name: "#{disk_name}", zone: "#{zone}") do
    it { should exist }
    its('type') { should match 'pd-ssd' }
    its('size_gb') { should eq "#{disk_size}" }
  end

  describe google_compute_instance(project: "#{project_id}",  zone: "#{zone}", name: "#{instance_name}") do
    it { should exist }
    its('name') { should eq "#{instance_name}" }
    its('zone') { should match "#{zone}" }
    its('status') { should eq 'RUNNING' }
    its('labels_keys') { should include 'role' }
    its('network_interfaces_count'){should eq 1}
  end
end
