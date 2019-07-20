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

#gcloud compute routers describe datalab-network-default-router --project boblee-test-225418 --region us-central1
#gcloud --project boblee-test-225418 compute routers nats describe datalab-network-default-nat --router datalab-network-default-router --region us-central1 --format json

project_id = attribute('project_id')
region = attribute('region')
router_name = attribute('router_name')
nat_name = attribute('nat_name')
subnet_name = attribute('subnet_name')

control "nat" do
  title "Google Compute NAT configuration"
  describe command("gcloud --project #{project_id} compute routers nats describe #{nat_name} --router #{router_name} --router-region #{region} --format json") do
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
end

control "gcloud" do
  title "gcloud"

  describe command("gcloud --project=#{attribute("project_id")} services list --enabled") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match "storage-api.googleapis.com" }
  end
end
