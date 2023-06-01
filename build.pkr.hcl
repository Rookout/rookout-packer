locals {

  controller_image      = "${var.controller_image}:${var.controller_version}"
  controller_token      = "ROOKOUT_TOKEN=$${ROOKOUT_TOKEN}"
  controller_cert_mount = "$${ROOKOUT_CONTROLLER_CERT_PATH}:/var/controller-tls-secrets/"
  controller_cert_path  = "/etc/rookout/controller/certs"

  dop_image      = "${var.dop_image}:${var.dop_version}"
  dop_token      = "ROOKOUT_DOP_LOGGING_TOKEN=$${ROOKOUT_TOKEN}"
  dop_cert_mount = "$${ROOKOUT_DOP_CERT_PATH}:/var/rookout/"
  dop_cert_path  = "/etc/rookout/data-onprem/certs"

  uuid       = substr(uuidv4(), 0, 8)
  date       = legacy_isotime("2006-01-02")
  build_name = "${var.name}-${var.linux_distro}-${local.date}-${local.uuid}"

}

build {

  name = var.name

  sources = var.sources

  provisioner "shell-local" {
    inline = [
      "echo =======================================================",
      "echo Hello from ${source.type}.${source.name} ${var.name} ${build.Host}" ,
      "echo =======================================================",
    ]
  }

  provisioner "shell" {
    script = "scripts/install-docker-${var.linux_distro}.sh"
  }

  provisioner "file" {
    content = templatefile(("templates/config.tpl"),
      {
        token = var.token
    })
    destination = "/tmp/config"
  }

  provisioner "file" {
    content = templatefile(("templates/controller/env.tpl"),
      {
        server_mode = var.server_mode
        port        = var.controller_port
        certs_path  = local.controller_cert_path
    })
    destination = "/tmp/controller_env"
  }

  provisioner "file" {
    content = templatefile(("templates/data-onprem/env.tpl"),
      {
        server_mode = var.server_mode
        port        = var.dop_port
        certs_path  = local.dop_cert_path
    })
    destination = "/tmp/dop_env"
  }

  provisioner "file" {
    content = templatefile(("templates/systemd-unit.tpl"),
      {
        description = "Rookout Controller Service"
        name        = "controller"
        image       = local.controller_image
        token       = local.controller_token
        certs_mount = local.controller_cert_mount
    })
    destination = "/tmp/rookout-controller.service"
  }

  provisioner "file" {
    content = templatefile(("templates/systemd-unit.tpl"),
      {
        description = "Rookout DOP Service"
        name        = "data-onprem"
        image       = local.dop_image
        token       = local.dop_token
        certs_mount = local.dop_cert_mount
    })
    destination = "/tmp/rookout-data-on-prem.service"
  }

  provisioner "file" {
    source = "files/scripts/netplan_config.sh"
    destination = "/tmp/netplan_config.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/netplan_config.sh $HOME",
      "sudo chmod +x $HOME/netplan_config.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo mkdir -p ${local.controller_cert_path}",
      "sudo mkdir -p ${local.dop_cert_path}",
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo docker pull ${local.controller_image}",
      "sudo docker pull ${local.dop_image}"
    ]
  }


  provisioner "shell" {
    script = "scripts/rookout-startup.sh"
  }

  
  provisioner "shell" {
    script = "scripts/secure_ami.sh"
  }

  
  provisioner "shell-local" {
    environment_vars = [
        "TARGET_USER=ubuntu",
        "HOST_KEY=${build.SSHPrivateKey}",
        "SPEC_NAME=${source.name}",
        "HOST=${build.Host}"
    ]
    inline = [
      "if [[ ${var.tests} != \"true\" ]];then exit 0;fi",
      "echo =======================================================",
      "echo Running RSpec tests ${source.type}.${source.name} ${var.name}",
      "echo =======================================================",
      "cd tests/ && rake spec"
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "ROOKOUT_TOKEN=${var.token}"
    ]
    script = "scripts/cleanup.sh"
  }

  provisioner "shell-local" {
    environment_vars = [
        "TARGET_USER=ubuntu",
        "HOST_KEY=${build.SSHPrivateKey}",
        "SPEC_NAME=cleanup",
        "HOST=${build.Host}"
    ]
    inline = [
      "if [[ ${var.tests} != \"true\" ]];then exit 0;fi",
      "echo =======================================================",
      "echo Running RSpec tests ${source.type}.${source.name} ${var.name}",
      "echo =======================================================",
      "cd tests/ && rake spec"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo === Cleaning Up Public Keys ===",
      "sudo shred -u /etc/ssh/*_key /etc/ssh/*_key.pub",
    ]
  }


  post-processor "shell-local" {
    inline = [
      "echo =======================================================",
      "echo Good Buy from ${source.type}.${source.name} ${var.name}",
      "echo ======================================================="
    ]
  }
}
