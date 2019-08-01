- path: /etc/nvidia-installer-env
  permissions: 0755
  owner: root
  content: |
    NVIDIA_DRIVER_VERSION=418.67
    COS_NVIDIA_INSTALLER_CONTAINER=gcr.io/cos-cloud/cos-gpu-installer:latest
    NVIDIA_INSTALL_DIR_HOST=/var/lib/nvidia
    NVIDIA_INSTALL_DIR_CONTAINER=/usr/local/nvidia
    ROOT_MOUNT_DIR=/root

- path: /etc/systemd/system/cos-gpu-installer.service
  permissions: 0755
  owner: root
  content: |
    [Unit]
    Description=Run the GPU driver installer container
    Requires=network-online.target gcr-online.target wait-for-startup-script.service
    After=network-online.target gcr-online.target wait-for-startup-script.service

    [Service]
    User=root
    Type=oneshot
    RemainAfterExit=true
    Environment="HOME=/home/datalab"
    EnvironmentFile=/etc/nvidia-installer-env
    ExecStartPre=/usr/bin/docker-credential-gcr configure-docker
    ExecStartPre=/bin/bash -c 'mkdir -p "$${NVIDIA_INSTALL_DIR_HOST}" && \
        mount --bind "$${NVIDIA_INSTALL_DIR_HOST}" \
        "$${NVIDIA_INSTALL_DIR_HOST}" && \
        mount -o remount,exec "$${NVIDIA_INSTALL_DIR_HOST}"'
    ExecStart=/usr/bin/docker run --privileged --net=host --pid=host \
        --volume \
        "$${NVIDIA_INSTALL_DIR_HOST}":"$${NVIDIA_INSTALL_DIR_CONTAINER}" \
        --volume /dev:/dev --volume "/":"$${ROOT_MOUNT_DIR}" \
        --env-file /etc/nvidia-installer-env \
        "$${COS_NVIDIA_INSTALLER_CONTAINER}"
    StandardOutput=journal+console
    StandardError=journal+console

- path: /etc/systemd/system/datalab.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=datalab docker container
    Requires=network-online.target gcr-online.target \
       wait-for-startup-script.service cos-gpu-installer.service
    After=network-online.target gcr-online.target \
       wait-for-startup-script.service cos-gpu-installer.service
    [Service]
    Environment="HOME=/home/datalab"
    ExecStartPre=/usr/bin/docker-credential-gcr configure-docker
    ExecStart=/usr/bin/docker run \
       --name=datalab \
       -p '8080:8080' \
       -v /mnt/disks/datalab-pd/content:/content \
       -v /mnt/disks/datalab-pd/tmp:/tmp \
       --volume /var/lib/nvidia:/usr/local/nvidia \
${gpu_device}       --device /dev/nvidia-uvm:/dev/nvidia-uvm \
       --device /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools \
       --device /dev/nvidiactl:/dev/nvidiactl \
       --env=HOME=/content \
       --env=DATALAB_ENV=GCE \
       --env=DATALAB_DEBUG=true \
       --env='DATALAB_SETTINGS_OVERRIDES={"enableAutoGCSBackups": ${datalab_enable_backup}, "consoleLogLevel": "${datalab_console_log_level}"}' \
       --env='DATALAB_GIT_AUTHOR=${datalab_user_email}' \
       --env='DATALAB_INITIAL_USER_SETTINGS={"idleTimeoutInterval": "${datalab_idle_timeout}"}' \
       ${datalab_docker_image} -c /datalab/run.sh
    ExecStop=-/usr/bin/docker stop datalab
    ExecStopPost=-/usr/bin/docker rm -f datalab
    Restart=always
    RestartSec=1
