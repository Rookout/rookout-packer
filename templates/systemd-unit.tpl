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
    --health-cmd "echo -e 'GET / HTTP/1.1\r\nHost: localhost\r\n\r\n' | nc localhost ${port} || exit 1" \
    --health-interval 5s \
    --health-retries 3 \
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