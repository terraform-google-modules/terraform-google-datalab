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
subnet_name = attribute('subnet_name')
instance_name = attribute('instance_name')

control "gcloud" do
  title "Google Compute NAT configuration"
  describe command("gcloud --project #{project_id} compute routers nats describe #{nat_name} \
  --router #{router_name} --router-region #{region} --format json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "nat" do
      it "matches nat name" do
        expect(data["name"]).to eq("#{nat_name}")
      end

      it "is IP allocation to auto" do
        expect(data["natIpAllocateOption"]).to eq("AUTO_ONLY")
      end

      it "is subnet IP range set" do
        expect(data["sourceSubnetworkIpRangesToNat"]).to eq("LIST_OF_SUBNETWORKS")
      end

      it "is subnetwork in the NAT" do
        expect(data["subnetworks"][0]).to eq({
          "name" => "#{subnet_name}",
          "sourceIpRangesToNat" => ["ALL_IP_RANGES"],
        })
      end

    end
  end

  title "Test Web UI access"
  describe command("timeout 5s gcloud beta compute start-iap-tunnel #{instance_name} 8080 \
  --project #{project_id} --zone #{zone} --local-host-port=localhost:8080") do
    its('stdout') { should match (/Listening on port \[8080\]/) }
  end
end