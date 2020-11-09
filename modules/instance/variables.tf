variable "ami" {
  description = "Id of the image to use"
}

variable "extra_security_groups" {
  default     = []
  description = "Extra security groups to associate to the AWS instance"
}

variable "ingresses" {
  description = "Ingress values"
  type        = list
}

variable "instance_type" {
  description = "Instance type to use"
}

variable "sg_description" {
  description = "Security group's description"
}

variable "sg_name" {
  description = "Security group's name"
}

variable "subnet" {
  description = "Subnet of the AWS instance"
}

variable "vpc" {
  description = "VPC for the security group"
}
