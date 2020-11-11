resource "cloudflare_record" "subdomain" {
  name    = var.hostname.subdomain
  proxied = false
  type    = "CNAME"
  value   = module.webserver.loadbalancer_dns_name
  zone_id = var.cloudflare_zone_id
}
