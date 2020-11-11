resource "aws_acm_certificate" "cert" {
  domain_name       = "pix4d.davidmogar.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      record_name  = dvo.resource_record_name
      record_type  = dvo.resource_record_type
      record_value = replace(dvo.resource_record_value, "/[.]$/", "")
    }
  }
  name    = each.value.record_name
  proxied = false
  type    = each.value.record_type
  value   = each.value.record_value
  zone_id = var.cloudflare_zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for _, cert in cloudflare_record.cert : cert.hostname]
}
