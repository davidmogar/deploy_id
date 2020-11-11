variable "ami" {
  description = "Map containing the image id for each region"
  type        = map
}

variable "cloudflare_zone_id" {
  description = "The DNS zone ID to add the record to"
}

variable "hostname" {
  default = {
    "subdomain" : "pix4d"
    "domain" : "davidmogar.com"
  }
  description = "Hostname components"
}

variable "instance" {
  default     = "t2.micro"
  description = "Intance type to use"
}

variable "region" {
  description = "Region in which to make the deployments"
}

variable "ssh_key_path" {
  default     = "~/.ssh/id_rsa"
  description = "Path to the key to use for SSH connections"
}

variable "ssh_public_key_path" {
  default     = "~/.ssh/id_rsa"
  description = "Path to the public key to use for SSH connections"
}

variable "ssh_user" {
  description = "User to use for SSH connections"
}

variable "website_repository" {
  description = "Path to the repository with the website to deploy in the webserver"
}
