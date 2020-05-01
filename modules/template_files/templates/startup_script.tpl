#!/bin/bash
#
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# First, make sure the `datalab` and `logger` users exist with their
# home directories setup correctly.
useradd datalab -u 2000 || useradd datalab
useradd logger -u 2001 || useradd logger

# In case the instance has started before, the `/home/datalab` directory
# may already exist, but with the incorrect user ID (since `/etc/passwd`
# is saved in a tmpfs and changes after restarts). To account for that,
# we should force the file ownership under `/home/datalab` to match
# the current UID for the `datalab` user.
chown -R datalab /home/datalab
chown -R logger /home/logger

PERSISTENT_DISK_DEV="/dev/disk/by-id/google-${disk_name}"
MOUNT_DIR="/mnt/disks/datalab-pd"
MOUNT_CMD="mount -o discard,defaults $${PERSISTENT_DISK_DEV} $${MOUNT_DIR}"

download_docker_image() {
  # Since /root/.docker is not writable on the default image,
  # we need to set HOME to be a writable directory. This same
  # directory is used later on by the datalab.service.
  export OLD_HOME=$HOME
  export HOME=/home/datalab
  echo "Getting Docker credentials"
  docker-credential-gcr configure-docker
  echo "Pulling latest image: ${datalab_docker_image}"
  docker pull ${datalab_docker_image}
  export HOME=$OLD_HOME
}

clone_repo() {
  echo "Creating the datalab directory"
  mkdir -p $${MOUNT_DIR}/content/datalab
  echo "Cloning the repo datalab-notebooks"
  docker run --rm -v "$${MOUNT_DIR}/content:/content" \
    --entrypoint "/bin/bash" ${datalab_docker_image} \
    gcloud source repos clone datalab-notebooks /content/datalab/notebooks
}

repo_is_populated() {
  cd $${MOUNT_DIR}/content/datalab/notebooks
  git show-ref --quiet
}

populate_repo() {
  echo "Populating datalab-notebooks repo"
  docker run --rm -v "$${MOUNT_DIR}/content:/content" \
    --workdir=/content/datalab/notebooks \
    --entrypoint "/bin/bash"  ${datalab_docker_image} -c "\
        echo '.ipynb_checkpoints' >> .gitignore; \
        echo '*.pyc' >> .gitignore; \
        echo '# Project Notebooks' >> README.md; \
        git add .gitignore README.md; \
        git -c user.email=nobody -c user.name=Datalab \
          commit --message='Set up initial notebook repo.'; \
        git push origin master; \
    "
}

format_disk() {
  echo "Formatting the persistent disk"
  mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard $${PERSISTENT_DISK_DEV}
  $${MOUNT_CMD}
  clone_repo
  if ! repo_is_populated; then
    populate_repo
  fi
}

checked_format_disk() {
  echo "Checking if the persistent disk needs to be formatted"
  if [ -z "$(blkid $${PERSISTENT_DISK_DEV})" ]; then
    format_disk
  else
    echo "Disk already formatted, but mounting failed"

    # The mount failed, but the disk seems to already
    # be formatted.
    exit 1
  fi
}

mount_and_prepare_disk() {
  echo "Trying to mount the persistent disk"
  mkdir -p "$${MOUNT_DIR}"
  $${MOUNT_CMD} || checked_format_disk

  if [ -z "$(mount | grep $${MOUNT_DIR})" ]; then
    echo "Failed to mount the persistent disk;"
    exit 1
  fi

  chmod a+w "$${MOUNT_DIR}"
  mkdir -p "$${MOUNT_DIR}/content"

  old_dir="$${MOUNT_DIR}/datalab"
  new_dir="$${MOUNT_DIR}/content/datalab"
  if [ -d "$${old_dir}" ] && [ ! -d "$${new_dir}" ]; then
    echo "Moving $${old_dir} to $${new_dir}"
    mv "$${old_dir}" "$${new_dir}"
  else
    echo "Creating $${new_dir}"
    mkdir -p "$${new_dir}"
  fi
}

configure_swap() {
  if [ "${datalab_enable_swap}" == "false" ]; then
    return
  fi
  mem_total_line=`cat /proc/meminfo | grep MemTotal`
  mem_total_value=`echo "$${mem_total_line}" | cut -d ':' -f 2`
  memory_kb=`echo "$${mem_total_value}" | cut -d 'k' -f 1 | tr -d '[:space:]'`

  # Before proceeding, check if we have more disk than memory.
  # Specifically, if the free space on disk is not N times the
  # size of memory, then enabling swap makes no sense.
  #
  # Arbitrarily choosing a value of N=10
  disk_kb_cutoff=`expr 10 "*" $${memory_kb}`
  disk_kb_available=`df --output=avail $${MOUNT_DIR} | tail -n 1`
  if [ "$${disk_kb_available}" -lt "$${disk_kb_cutoff}" ]; then
    return
  fi

  swapfile="$${MOUNT_DIR}/swapfile"

  # Create the swapfile if it is either missing or not big enough
  current_size="0"
  if [ -e "$${swapfile}" ]; then
    current_size=`ls -s $${swapfile} | cut -d ' ' -f 1`
  fi
  if [ "$${memory_kb}" -gt "$${current_size}" ]; then
    echo "Creating a $${memory_kb} kilobyte swapfile at $${swapfile}"
    dd if=/dev/zero of="$${swapfile}" bs=1024 count="$${memory_kb}"
  fi
  chmod 0600 "$${swapfile}"
  mkswap "$${swapfile}"

  # Enable swap
  sysctl vm.disk_based_swap=1
  swapon "$${swapfile}"
}

cleanup_tmp() {
  tmpdir="$${MOUNT_DIR}/tmp"

  # First, make sure the temporary directory exists.
  mkdir -p "$${tmpdir}"

  # Remove all files from it.
  #
  # We do not remove the directory itself, as that could lead to a broken
  # volume mount if the Docker container has already started).
  #
  # We also do not just use `rm -rf $${tmpdir}/*`, as that would leave
  # behind any hidden files.
  find "$${tmpdir}/" -mindepth 1 -delete
}

download_docker_image
mount_and_prepare_disk
configure_swap
cleanup_tmp

journalctl -u google-startup-scripts --no-pager > /var/log/startupscript.log
