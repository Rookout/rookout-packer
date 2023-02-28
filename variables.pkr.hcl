//  variables.pkr.hcl

// For those variables that you don't provide a default for, you must
// set them from the command line, a var-file, or the environment.
variable "name" {
    type        = string
    default     = "rookout-hybrid"
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
    sensitive   = true
}

variable "server_mode" {
    type = string
    default = "PLAIN"
    sensitive   = false
}

variable "controller_image" {
    type = string
    default = "rookout/controller"
    description = "Controller Image"
    sensitive   = false
}

variable "controller_version" {
    type = string
    default = "latest"
    description = "Controller Image Tag"
    sensitive   = false
}

variable "controller_port" {
    default = 7488
    description = "Controller port"
    sensitive   = false
}

variable "dop_image" {
    type = string
    default = "rookout/data-on-prem"
    description = "Data-On-Prem Image"
    sensitive   = false
}

variable "dop_version" {
    type = string
    default = "latest"
    description = "Data-On-Prem Image Tag"
    sensitive   = false
}

variable "dop_port" {
    default = 8080
    description = "Data-On-Prem port"
    sensitive   = false
}