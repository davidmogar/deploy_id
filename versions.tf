terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    acme = {
      source  = "terraform-providers/acme"
      version = "~> 1.5"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.13"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.13"
}
