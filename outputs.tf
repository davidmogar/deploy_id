output "bastion_public_ip" {
  description = "SSH bastion's Public IP"
  value       = aws_instance.bastion.public_ip
}

output "backend_private_ip" {
  description = "Private IP in front of the backend server"
  value       = aws_instance.backend.private_ip
}

output "backend_public_ip" {
  description = "Public IP in front of the backend server"
  value       = aws_instance.backend.public_ip
}

output "webserver_private_ip" {
  description = "Private IP in front of the webserver"
  value       = aws_instance.webserver.private_ip
}
output "webserver_public_ip" {
  description = "Public IP in front of the webserver"
  value       = aws_instance.webserver.public_ip
}
