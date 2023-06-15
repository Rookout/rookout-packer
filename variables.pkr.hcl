//  variables.pkr.hcl

// For those variables that you don't provide a default for, you must
// set them from the command line, a var-file, or the environment.
variable "name" {
  type        = string
  default     = "rookout"
  description = "Build name"
  sensitive   = false
}

variable "linux_distro" {
  type        = string
  default     = "ubuntu"
  description = "linux distro rhel/centos/ubuntu"
  sensitive   = false
}

variable "token" {
  type        = string
  description = "Rookout Token"
  default     = env("ROOKOUT_TOKEN")
  sensitive   = true
}

variable "server_mode" {
  type      = string
  default   = "PLAIN"
  sensitive = false
}

variable "controller_image" {
  type        = string
  default     = "rookout/controller"
  description = "Controller Image"
  sensitive   = false
}

variable "controller_version" {
  type        = string
  default     = "latest"
  description = "Controller Image Tag"
  sensitive   = false
}

variable "controller_port" {
  default     = 7488
  description = "Controller port"
  sensitive   = false
}

variable "dop_image" {
  type        = string
  default     = "rookout/data-on-prem"
  description = "Data-On-Prem Image"
  sensitive   = false
}

variable "dop_version" {
  type        = string
  default     = "latest"
  description = "Data-On-Prem Image Tag"
  sensitive   = false
}

variable "dop_port" {
  default     = 8080
  description = "Data-On-Prem port"
  sensitive   = false
}

variable "ubuntu_version" {
  default     = "20.04.5"
  description = "Ubuntu Version"
  sensitive   = false
}

variable "aws_instance_type" {
  default     = "c5.large"
  description = "AWS instance type"
}

variable "aws_source_ami" {
  default     = "ubuntu-jammy-22.04-amd64-server"
  description = "Source AMI filter"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_access_key" {
  type      = string
  sensitive = true
  default   = env("AWS_ACCESS_KEY_ID")
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
  default   = env("AWS_SECRET_ACCESS_KEY")
}

variable "aws_vpc_id" {
  type = string
}

variable "sources" {
  type = list(string)
  default = [
    //    "sources.vmware-iso.ubuntu",
    "sources.amazon-ebs.aws",
  ]
}

variable "tests" {
  type    = string
  default = "true"
}

variable "ami_version" {
  type        = string
  default     = "0.0.0"
  description = "AMI Semantic version"
}