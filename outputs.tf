output "nginx_ip" {
  description = "Public IP in front of the NGINX server"
  value       = aws_instance.nginx.public_ip
}
