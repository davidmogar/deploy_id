output "nginx_ip" {
  description = "Public IP in front of the NGINX server"
  value       = aws_eip.nginx.public_ip
}
