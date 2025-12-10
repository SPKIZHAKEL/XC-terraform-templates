locals {
  domains = var.domains
}
resource "volterra_cdn_loadbalancer" "cdn-lb" {
  for_each    = toset(local.domains)
  name        = "cdn-${split(".", each.value)[0]}"
  namespace   = var.namespace
  description = "cdn distribution for ${each.value}"
  domains     = ["cdn-${each.value}"]
  labels      = var.labels

  https {
    tls_cert_options {
      tls_cert_params {
        certificates {
          name      = <cert name>
          namespace = var.namespace
        }
      }
    }
  }
  origin_pool {
    public_name {
      dns_name = each.value
    }
    origin_servers {
      public_ip {
        ip = "1.1.1.1"
      }
      port = 443
    }
    use_tls {
      default_session_key_caching = true
      tls_config {
        default_security = true
      }
    }

  }
  disable_waf = true
}