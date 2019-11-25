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
gpu_count = attribute('gpu_count')
gpu_type = attribute('gpu_type')

include_controls 'shared'

control "gpu" do
  title "check gpu"

  # Check to make sure that the gpu type and count are correct for the GPU instance
  describe command("gcloud compute instances describe #{instance_name} --project #{project_id} --zone #{zone} --format json") do
    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "check that gpu(s) are set" do
      expect(data["guestAccelerators"][0]).to include({
        "acceleratorCount" => attribute('gpu_count'),
        "acceleratorType" => "https://www.googleapis.com/compute/v1/projects/#{project_id}/zones/#{zone}/acceleratorTypes/#{attribute('gpu_type')}",
      })
    end
  end

end
