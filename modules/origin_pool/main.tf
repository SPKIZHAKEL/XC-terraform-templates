locals {
  cdn_cname = var.cdn_cname
}
resource "volterra_origin_pool" "cdn-origin-pool" {
  for_each               = toset(var.cdn_domain)
  name                   = split(".", each.value)[0]
  namespace              = var.namespace
  loadbalancer_algorithm = "Load Balancer Override"
  endpoint_selection     = "Local Endpoints Preferred"
  origin_servers {
    public_name {
      dns_name = local.cdn_cname[index(var.cdn_domain, each.value)]
    }
  }
  port = 443
  use_tls {
    default_session_key_caching = true
    no_mtls                     = true
    skip_server_verification    = true
    use_host_header_as_sni      = true
    tls_config {
      default_security = true
    }
  }
  labels = var.labels
}