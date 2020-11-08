output "webserver_private_ip" {
  description = "Private IP in front of the webserver"
  value       = aws_instance.webserver.private_ip
}
output "webserver_public_ip" {
  description = "Public IP in front of the webserver"
  value       = aws_instance.webserver.public_ip
}
