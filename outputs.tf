output "backend_private_ip" {
  description = "Private IP in front of the backend server"
  value       = module.backend.private_ip
}

output "backend_public_ip" {
  description = "Public IP in front of the backend server"
  value       = module.backend.public_ip
}

output "bastion_private_ip" {
  description = "Bastion's private IP"
  value       = module.bastion.private_ip
}

output "bastion_public_ip" {
  description = "Bastion's public IP"
  value       = module.bastion.public_ip
}

output "webserver_hostname" {
  description = "Hostname in front of the webserver"
  value       = "${var.hostname.subdomain}.${var.hostname.domain}"
}

output "webserver_private_ip" {
  description = "Private IP in front of the webserver"
  value       = module.webserver.private_ip
}
output "webserver_public_ip" {
  description = "Public IP in front of the webserver"
  value       = module.webserver.public_ip
}
