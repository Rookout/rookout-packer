locals {
  uuid       = substr(uuidv4(), 0, 8)
  date       = legacy_isotime("2006-01-02")
  build_name = "${var.name}-${var.linux_distro}-${local.date}-${local.uuid}"
}

// The boot_command is voodoo, i got it "worked on my machine" with blood, 
// if it not work for you, use documentation for reference https://developer.hashicorp.com/packer/plugins/builders/vmware/iso#boot-configuration
source "vmware-iso" "ubuntu" {
  vm_name                = local.build_name
  output_directory       = local.build_name
  format                 = "ova"
  iso_url                = "https://releases.ubuntu.com/${var.ubuntu_version}/ubuntu-${var.ubuntu_version}-live-server-amd64.iso"
  iso_checksum           = "file:https://releases.ubuntu.com/${var.ubuntu_version}/SHA256SUMS"
  ssh_username           = "admin"
  ssh_password           = "packerubuntu"
  ssh_timeout            = "30m"
  ssh_handshake_attempts = "100"
  shutdown_command       = "echo 'packerubuntu' | sudo -S shutdown -P now"
  memory         = 4096
  cores          = 2
  http_directory = "http"
  boot_wait      = "5s"
  boot_command = [
    "c<wait>",
    "<esc><wait>",
    "<esc><wait>",
    "<enter><wait>",
    "/casper/vmlinuz root=/dev/sr0 initrd=/casper/initrd autoinstall ",
    "ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<wait>",
    "<enter>"
  ]
  headless = false # NOTE: set this to true when using in CI Pipelines   
}


// null source for quickly provisioners by simple sshing to remote machine, not used in build sources
source "null" "ssh" {
  communicator         = "ssh"
  ssh_host             = "44.211.238.191"
  ssh_username         = "ubuntu"
  ssh_agent_auth       = true
  ssh_keypair_name     = "rookout-sdk-1ws"
  ssh_certificate_file = "/Users/alexeygutkin/Downloads/rookout-sdk-1ws.pem"
}