[Unit]
Description=${description}
Requires=docker.service
After=docker.service

[Service]
Restart=always
EnvironmentFile=/etc/rookout/config
ExecStart=/usr/bin/docker run --network host \
    -p ${port} \
    -e ${token} \
    -e ${server_mode} \
    --name ${name} \
    ${image}
ExecStop=/usr/bin/docker stop ${name}
ExecStopPost=/usr/bin/docker rm ${name}
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target