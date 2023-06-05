[Unit]
Description=${description}
Requires=docker.service
After=docker.service

[Service]
Restart=always
EnvironmentFile=/etc/rookout/config
EnvironmentFile=/etc/rookout/${name}/env
ExecStartPre=-/usr/bin/docker rm rookout-${name}
ExecStart=/usr/bin/docker run \
    ${health_check} \
    --network host \
    -v ${certs_mount} \
    --env-file /etc/rookout/${name}/env \
    -e ${token} \
    --name rookout-${name} \
    ${image}
ExecStop=/usr/bin/docker stop rookout-${name}
ExecStopPost=/usr/bin/docker rm rookout-${name}
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target