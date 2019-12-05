# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
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
  title "gcloud Shared Resources"

  # Start the instance if it is not running. Instances have and idle timeout
  describe command("gcloud compute instances start #{instance_name} --async --project #{project_id} --zone #{zone}") do
    its(:exit_status) { should eq 0 }
  end

  # Check to make sure that labels are correct
  describe command("gcloud compute instances describe #{instance_name} --project #{project_id} --zone #{zone} --format json") do
    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "check that label is set" do
      expect(data["labels"]).to include({
        attribute('test_label_name') => attribute('test_label_value'),
        "role"                       => "datalab",
      })
    end
  end

  # Check to make sure that the cloud router is configured
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

end

# This control is not set to automatically run.  When the instances come up it can take a while before
# the container comes up and is in a ready state.  It can take longer for the GPU instances because
# of the installation of the GPU drivers
control "container" do
  title "check the datalab container"

  # Verify that the docker container is running
  describe command("gcloud beta compute --project #{project_id} ssh --zone #{zone} \
  datalab --tunnel-through-iap --command='docker inspect datalab'") do
    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "check that datalab continer is running" do
      expect(data[0]["State"]).to include({
        "Status" => "running",
      })
    end
  end

  # Verify that the container is listening on port 8080 and we can connect
  describe command("timeout 5s gcloud beta compute start-iap-tunnel #{instance_name} 8080 \
  --project #{project_id} --zone #{zone} --local-host-port=localhost:8080") do
    its('stdout') { should match (/Listening on port \[8080\]/) }
  end

end
