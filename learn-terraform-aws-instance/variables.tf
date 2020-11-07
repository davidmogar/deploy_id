variable "region" {
  default = "eu-west-3"
}

variable "amis" {
  type = map
  default = {
    "eu-west-2" = "ami-bd3622d9"
    "eu-west-3" = "ami-050370d642c2f4559"
  }
}
