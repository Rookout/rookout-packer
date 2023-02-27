locals {   
    controller_image = "${var.controller_image}:${var.controller_version}"
    controller_server_mode = "ROOKOUT_CONTROLLER_SERVER_MODE=${var.controller_server_mode}"
    controller_token = "ROOKOUT_TOKEN=${var.token}"

    dop_image = "${var.dop_image}:${var.dop_version}"
    dop_server_mode = "ROOKOUT_DOP_SERVER_MODE=${var.dop_server_mode}"
    dop_token = "ROOKOUT_DOP_LOGGING_TOKEN=${var.token}"
    dop_additional_envs = "-e ROOKOUT_DOP_PORT=${var.dop_port} -e ROOKOUT_DOP_IN_MEMORY_DB=${var.dop_in_memory_db}"
}

// Temporary Null builder just for testing
source "null" "ssh" {
    communicator = "ssh"
    ssh_host = "54.242.197.16"
    ssh_username = "ec2-user"
    ssh_agent_auth = true
    ssh_keypair_name = "rookout-sdk-1w"
    ssh_certificate_file = "~/Downloads/rookout-sdk-1ws.pem"
}

build {

    name = var.name

    sources = [
        "sources.null.ssh",
    ]

    provisioner "shell-local" {
        inline = ["echo Hello from ${source.type}.${source.name} ${var.name}"]
    }

    # Install docker (not tested yet)
    # provisioner "shell" {
    #     script = "scripts/install-docker-${var.linux_distro}"
    # }

    # provisioner "shell" {
    #     script = "scripts/post-install-docker.sh"
    # }

    provisioner "file" {
        content = templatefile(("templates/systemd-unit.tpl"),
        {
            description = "Rookout Controller Service"
            name = "rookout-controller"
            image = local.controller_image
            port = var.controller_port
            token = local.controller_token
            server_mode = local.controller_server_mode
            additional_envs = ""
        })
        destination = "/tmp/rookout-controller.service"
    }

    provisioner "file" {
        content = templatefile(("templates/systemd-unit.tpl"),
        {
            description = "Rookout DOP Service"
            name = "rookout-data-onprem"
            image = local.dop_image
            port = var.dop_port
            token = local.dop_token
            server_mode = local.dop_server_mode
            additional_envs = local.dop_additional_envs
        })
        destination = "/tmp/rookout-data-on-prem.service"
    }

    provisioner "shell" {
        inline = [
            "sudo mv /tmp/*.service /lib/systemd/system/",
            "sudo systemctl daemon-reload",
            "sudo systemctl start rookout-data-on-prem.service",
            "sudo systemctl start rookout-controller.service",
            "sudo systemctl enable rookout-data-on-prem.service",
            "sudo systemctl enable rookout-controller.service",
        ]
    }

    post-processor "shell-local" {
        inline = ["echo Good Buy from ${source.type}.${source.name}"]
    }
}



