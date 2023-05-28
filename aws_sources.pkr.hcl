
data "amazon-ami" "source-ami" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/hvm-ssd/${var.aws_source_ami}-*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
}

source "amazon-ebs" "this" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  ami_name      = local.build_name
  instance_type = var.aws_instance_type
  vpc_id        = var.aws_vpc_id
  region        = var.aws_region
  source_ami    = data.amazon-ami.source-ami.id
  ssh_username  = "ubuntu"
  ssh_interface = "public_ip"
  communicator  = "ssh"
}


# ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230516
# ami-024e6efaf93d85776