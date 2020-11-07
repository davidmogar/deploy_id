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
