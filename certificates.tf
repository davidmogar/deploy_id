resource "tls_private_key" "webserver" {
  algorithm = "RSA"
}

resource "acme_registration" "webserver" {
  account_key_pem = tls_private_key.webserver.private_key_pem
  email_address   = "null@${var.hostname.domain}"
}

resource "acme_certificate" "webserver" {
  account_key_pem = acme_registration.webserver.account_key_pem
  common_name     = "${var.hostname.subdomain}.${var.hostname.domain}"

  dns_challenge {
    provider = "cloudflare"
  }
}

resource "tls_cert_request" "webserver" {
  key_algorithm   = tls_private_key.webserver.algorithm
  private_key_pem = tls_private_key.webserver.private_key_pem

  subject {
    common_name  = "${var.hostname.subdomain}.${var.hostname.domain}"
    organization = var.hostname.domain
  }
}

resource "cloudflare_origin_ca_certificate" "webserver" {
  csr                = tls_cert_request.webserver.cert_request_pem
  hostnames          = ["${var.hostname.subdomain}.${var.hostname.domain}"]
  request_type       = "origin-rsa"
  requested_validity = 365
}
