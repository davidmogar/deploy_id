variable "ami" {
  description = "Id of the image to use"
}

variable "description" {
  description = "Instance's description"
}

variable "extra_security_groups" {
  default     = []
  description = "Extra security groups to associate to the AWS instance"
}

variable "ingresses" {
  description = "Ingress values"
  type        = any
}

variable "instance_type" {
  description = "Instance type to use"
}

variable "loadbalancer" {
  default = null
  type = object({
    availability_zones = list(string)
    desired_capacity   = number
    listeners          = list(map(string))
    max_size           = number
    min_size           = number
  })
}

variable "name" {
  description = "Instance's name"
}

variable "subnet" {
  description = "Subnet of the AWS instance"
}

variable "user_data" {
  default     = ""
  description = "User data to provision the image(s) with"
}

variable "vpc" {
  description = "VPC for the security group"
}
