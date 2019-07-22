#cloud-config

users:
- name: datalab
  uid: 2000
  groups: docker
- name: logger
  uid: 2001
  groups: docker

write_files:
- path: /etc/systemd/system/wait-for-startup-script.service
  permissions: 0755
  owner: root
  content: |
    [Unit]
    Description=Wait for the startup script to setup required directories
    Requires=network-online.target gcr-online.target
    After=network-online.target gcr-online.target

    [Service]
    User=root
    Type=oneshot
    RemainAfterExit=true
        ExecStart=/bin/bash -c 'while [ ! -e /mnt/disks/datalab-pd/tmp ]; do \
        sleep 1; \
        done'

${datalab_gpu_partial}

${datalab_partial}

- path: /etc/google-fluentd/fluentd.conf
  permissions: 0644
  owner: root
  content: |
    # This config comes from a heavily trimmed version of the
    # container-engine-customize-fluentd project. The upstream config is here:
    # https://github.com/GoogleCloudPlatform/container-engine-customize-fluentd/blob/6a46d72b29f3d8e8e495713bc3382ce28caf744e/kubernetes/fluentd-configmap.yaml
    <source>
      type tail
      format json
      time_key time
      path /var/lib/docker/containers/*/*.log
      pos_file /var/log/google-fluentd/containers.log.pos
      time_format %Y-%m-%dT%H:%M:%S.%N%Z
      tag containers
      read_from_head true
    </source>
    <match **>
      @type copy
       <store>
        @type google_cloud
        # Set the buffer type to file to improve the reliability
        # and reduce the memory consumption
        buffer_type file
        buffer_path /var/log/google-fluentd/cos-system.buffer
        # Set queue_full action to block because we want to pause gracefully
        # in case of the off-the-limits load instead of throwing an exception
        buffer_queue_full_action block
        # Set the chunk limit conservatively to avoid exceeding the GCL limit
        # of 10MiB per write request.
        buffer_chunk_limit 2M
        # Cap the combined memory usage of this buffer and the one below to
        # 2MiB/chunk * (6 + 2) chunks = 16 MiB
        buffer_queue_limit 6
        # Never wait more than 5 seconds before flushing logs in the non-error
        # case.
        flush_interval 5s
        # Never wait longer than 30 seconds between retries.
        max_retry_wait 30
        # Disable the limit on the number of retries (retry forever).
        disable_retry_limit
        # Use multiple threads for processing.
        num_threads 2
      </store>
    </match>

- path: /etc/systemd/system/logger.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=logging docker container
    Requires=network-online.target
    After=network-online.target
    [Service]
    Environment="HOME=/home/logger"
    ExecStartPre=/usr/share/google/dockercfg_update.sh
    ExecStartPre=/bin/mkdir -p /var/log/google-fluentd/
    ExecStartPre=-/usr/bin/docker rm -fv logger
    ExecStart=/usr/bin/docker run --rm -u 0 \
       --name=logger \
       -v /var/log/:/var/log/ \
       -v /var/lib/docker/containers:/var/lib/docker/containers \
       -v /etc/google-fluentd/:/etc/fluent/config.d/ \
       --env='FLUENTD_ARGS=-q' \
       ${fluentd_docker_image}
    Restart=always
    RestartSec=1

runcmd:
- systemctl daemon-reload
${systemctl_gpu}
- systemctl start datalab.service
- systemctl start logger.service
