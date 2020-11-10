resource "cloudflare_record" "subdomain" {
  name    = var.hostname.subdomain
  proxied = true
  type    = "A"
  value   = module.webserver.public_ip
  zone_id = var.cloudflare_zone_id
}
