- path: /etc/systemd/system/datalab.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=datalab docker container
    Requires=network-online.target gcr-online.target \
             wait-for-startup-script.service
    After=network-online.target gcr-online.target \
          wait-for-startup-script.service
    [Service]
    Environment="HOME=/home/datalab"
    ExecStartPre=/usr/bin/docker-credential-gcr configure-docker
    ExecStart=/usr/bin/docker run \
       --name=datalab \
       -p '8080:8080' \
       -v /mnt/disks/datalab-pd/content:/content \
       -v /mnt/disks/datalab-pd/tmp:/tmp \
       --env=HOME=/content \
       --env=DATALAB_ENV=GCE \
       --env=DATALAB_DEBUG=true \
       --env='DATALAB_SETTINGS_OVERRIDES={"enableAutoGCSBackups": ${datalab_enable_backup}, "consoleLogLevel": "${datalab_console_log_level}"}' \
       --env='DATALAB_GIT_AUTHOR=${datalab_user_email}' \
       --env='DATALAB_INITIAL_USER_SETTINGS={"idleTimeoutInterval": "${datalab_idle_timeout}"}' \
       ${datalab_docker_image}
    ExecStop=-/usr/bin/docker stop datalab
    ExecStopPost=-/usr/bin/docker rm -f datalab
    Restart=always
    RestartSec=1
