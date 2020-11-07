variable "ami" {
  default = {
    "eu-west-3" = "ami-089d839e690b09b28"
  }
  type = map
}

variable "instance" {
  default = "t2.micro"
}

variable "region" {
  default = "eu-west-3"
}

variable "sg_egress_cidr" {
  type = list
}

variable "sg_ingress_cidr" {
  type = list
}

variable "ssh_key_path" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_user" {}

variable "website_repository" {}
