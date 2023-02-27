[Unit]
Description=${description}
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --network host -p ${port}:${port} -e ${token} -e ${server_mode} ${additional_envs} --name ${name} ${image}
ExecStop=/usr/bin/docker stop ${name}
ExecStopPost=/usr/bin/docker rm ${name}
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target