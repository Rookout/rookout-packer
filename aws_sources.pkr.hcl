locals {
  ami_tags = {
    Name               = "rookout-hybrid"
    date               = legacy_isotime("2006-01-02")
    controller_version = var.controller_version
    datastrore_version = var.dop_version
    ami_version        = var.ami_version
  }
}

data "amazon-ami" "source-ami" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/hvm-ssd/${var.aws_source_ami}-*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
}

source "amazon-ebs" "aws" {
  ami_name      = local.build_name
  instance_type = var.aws_instance_type
  vpc_id        = var.aws_vpc_id
  region        = var.aws_region
  source_ami    = data.amazon-ami.source-ami.id
  ssh_username  = "ubuntu"
  ssh_interface = "public_ip"
  communicator  = "ssh"
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 40
    volume_type           = "gp2"
    delete_on_termination = true
  }

  dynamic "tag" {
    for_each = local.ami_tags
    content {
      key   = tag.key
      value = tag.value
    }
  }

}