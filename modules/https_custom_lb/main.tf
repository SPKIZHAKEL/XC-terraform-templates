locals {


  # eg 5
  #   no_of_routes = sum([for domain in var.domains : len(domain)])
  # eg [3,2] [0,1,2,3,4] len-
  #   no_of_domains_per_lb = [for domain in var.domains : len(domain)]


  flattened_domains = flatten(var.domains)

}


resource "volterra_http_loadbalancer" "tf-demo-lb" {
  count                           = var.lb_count
  name                            = "tf-demo-lb-${count.index + 2}"
  namespace                       = var.namespace
  advertise_on_public_default_vip = true
  disable_api_definition          = true
  domains                         = ["test${count.index + 9}.random.xyz", "test${count.index + 11}.random.xyz"]
  https {
    http_redirect = true
    port          = 443
    tls_cert_params {
      tls_config {
        default_security = true
      }
      certificates {
        name      = <cert name>
        namespace = var.namespace
      }
    }
  }
  labels = var.labels
  app_firewall {
    name      = "app-fw-monitoring"
    namespace = var.namespace #hard coding monitoring
  }

  dynamic "routes" {

    for_each = var.domains[count.index]
    content {

      simple_route {
        path {
          prefix = "/"
        }
        headers {

          invert_match = false
          name         = "Host"

          exact = routes.value
        }
        http_method = "ANY"
        incoming_port {
          port = 443
        }
        origin_pools {
          pool {
            name      = "random-origin" #must be actually there
            namespace = var.namespace

          }
        }
        disable_host_rewrite = true
        # advanced_options {
        #   inherited_waf = true
        #   waf_exclusion_policy {

        #   }
        # }
      }

    }
  }

  l7_ddos_protection {
    mitigation_block       = true
    default_rps_threshold  = true
    clientside_action_none = true
    ddos_policy_none       = true
  }


}

# module "app_firewall" {
#   source       = "../app_firewall"
#   names        = ["app-fw-monitoring", "app-fw-blocking"]
#   namespace    = var.namespace
#   app_fw_count = 2

#   enforcement_mode = [{ monitoring = true, blocking = false }, { monitoring = false, blocking = true }]
# }



