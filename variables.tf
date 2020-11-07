variable "ami" {
  default = {
    "eu-west-3" = "ami-089d839e690b09b28"
  }
  description = "Map containing the image id for each region"
  type        = map
}

variable "instance" {
  default     = "t2.micro"
  description = "Intance type to use"
}

variable "region" {
  default     = "eu-west-3"
  description = "Region in which to make the deployments"
}

variable "sg_egress_cidr" {
  description = "CIDR to use for outgoing connections"
  type        = list
}

variable "sg_ingress_cidr" {
  description = "CIDR to use for incoming connections"
  type        = list
}

variable "ssh_key_path" {
  default     = "~/.ssh/id_rsa"
  description = "Path to the key to use for SSH connections"
}

variable "ssh_user" {
  description = "User to use for SSH connections"
}

variable "website_repository" {
  description = "Path to the repository with the website to deploy in the webserver"
}
