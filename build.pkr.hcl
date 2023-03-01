locals {
  controller_image       = "${var.controller_image}:${var.controller_version}"
  controller_server_mode = "ROOKOUT_CONTROLLER_SERVER_MODE=$${SERVER_MODE}"
  controller_token       = "ROOKOUT_TOKEN=$${ROOKOUT_TOKEN}"
  controller_port        = "$${ROOKOUT_CONTROLLER_PORT}:${var.controller_port}"

  dop_image       = "${var.dop_image}:${var.dop_version}"
  dop_server_mode = "ROOKOUT_DOP_SERVER_MODE=$${SERVER_MODE}"
  dop_token       = "ROOKOUT_DOP_LOGGING_TOKEN=$${ROOKOUT_TOKEN}"
  dop_port        = "$${ROOKOUT_DOP_PORT}:${var.dop_port}"
}

build {

  name = var.name

  sources = [
    "sources.vmware-iso.ubuntu",
  ]

  provisioner "shell-local" {
    inline = [
      "echo =======================================================",
      "echo Hello from ${source.type}.${source.name} ${var.name}",
      "echo =======================================================",
    ]
  }

  provisioner "shell" {
    script = "scripts/install-docker-${var.linux_distro}.sh"
  }

  provisioner "file" {
    content = templatefile(("templates/config.tpl"),
      {
        token           = var.token
        server_mode     = var.server_mode
        controller_port = var.controller_port
        dop_port        = var.dop_port
    })
    destination = "/tmp/config"
  }

  provisioner "file" {
    content = templatefile(("templates/systemd-unit.tpl"),
      {
        description = "Rookout Controller Service"
        name        = "rookout-controller"
        image       = local.controller_image
        port        = local.controller_port
        token       = local.controller_token
        server_mode = local.controller_server_mode
    })
    destination = "/tmp/rookout-controller.service"
  }

  provisioner "file" {
    content = templatefile(("templates/systemd-unit.tpl"),
      {
        description = "Rookout DOP Service"
        name        = "rookout-data-onprem"
        image       = local.dop_image
        port        = local.dop_port
        token       = local.dop_token
        server_mode = local.dop_server_mode
    })
    destination = "/tmp/rookout-data-on-prem.service"
  }

  provisioner "shell" {
    script = "scripts/rookout-startup.sh"
  }

  post-processor "shell-local" {
    inline = [
      "echo =======================================================",
      "echo Good Buy from ${source.type}.${source.name} ${var.name}",
      "echo ======================================================="
    ]
  }
}
