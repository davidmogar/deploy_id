terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "nginx" {
  name        = "nginx"
  description = "Allow traffic to http and ssh ports"

  egress {
    cidr_blocks = var.sg_egress_cidr
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  ingress {
    cidr_blocks = var.sg_ingress_cidr
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  ingress {
    cidr_blocks = var.sg_ingress_cidr
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
}

resource "aws_instance" "nginx" {
  ami                    = var.ami[var.region]
  instance_type          = var.instance
  vpc_security_group_ids = [aws_security_group.nginx.id]
}

resource "aws_eip_association" "nginx" {
  allocation_id = aws_eip.nginx.id
  instance_id   = aws_instance.nginx.id
}

resource "aws_eip" "nginx" {}
