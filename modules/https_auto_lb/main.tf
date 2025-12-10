locals {
  cdn_domain            = var.cdn_domain
  origin_pool_name_list = var.origin_pool_name_list
  # eg 5
  #   no_of_routes = sum([for domain in var.domains : len(domain)])
  # eg [3,2] [0,1,2,3,4] len-
  #   no_of_domains_per_lb = [for domain in var.domains : len(domain)]
  cdn_origin_pool_names = [for domain in local.cdn_domain : "${split(".", domain)[0]}"]

  flattened_domains = flatten(var.domains)

}


resource "volterra_http_loadbalancer" "tf-demo-lb" {
  count                           = var.lb_count
  name                            = "tf-demo-lb-${count.index}"
  namespace                       = var.namespace #hard code else make tfvars file
  advertise_on_public_default_vip = true
  disable_api_definition          = true
  domains                         = ["test${count.index + 5}.random.xyz", "test${count.index + 7}.random.xyz"]
  https_auto_cert {
    add_hsts = false
    port     = 443
    tls_config {
      default_security = true
    }
  }
  labels = var.labels
  app_firewall {
    name = module.app_firewall.app_fw_name[count.index]
  }

  dynamic "routes" {
    # custom_route_object {
    #   route_ref {
    #     name = module.custom_route_object.simple_route_name
    #   }
    # }

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
        http_method = "GET"
        incoming_port {
          port = 80
        }
        origin_pools {
          pool {
            name      = "random-origin-1"#some value that exists
            namespace = var.namespace

          }
        }
        host_rewrite = routes.value
        #   advanced_options {
        #   inherited_bot_defense_javascript_injection = true
        #   inherited_waf = true
        # inherited_waf_exclusion=true
        #   }


      }

    }
  }
  # custom_route_object {

  #     route_ref {
  #       name = "cdn-route"
  #       namespace = var.namespace
  #     }
  #   }

  l7_ddos_protection {
    mitigation_block       = true
    default_rps_threshold  = true
    clientside_action_none = true
    ddos_policy_none       = true
  }
  dynamic "routes" {
    # custom_route_object {
    #   route_ref {
    #     name = module.custom_route_object.simple_route_name
    #   }
    # }

    for_each = var.domains[count.index]
    content {

      simple_route {

        path {
          regex = ".*\\.(js|css|jpe?g|png|gif|webp|svg|woff2?|eot|ttf|otf|docx?|rtf|txt|pdf|mp3|wav|aac|flac|ogg|m4a|mp4|avi|wmv|mov|flv|mkv|webm|mpe?g)$"
        }
        headers {
          invert_match = false
          name         = "Host"
          exact        = routes.value
        }
        http_method = "ANY"
        incoming_port {
          port = 443
        }
        origin_pools {

          pool {

            name      = local.origin_pool_name_list[index(local.origin_pool_name_list, "cdn-${split(".", routes.value)[0]}")]
            namespace = var.namespace

          }
        }
        host_rewrite = "cdn-${routes.value}"
        #   advanced_options {
        #   inherited_bot_defense_javascript_injection = true
        #   inherited_waf = true
        # inherited_waf_exclusion=true
        #   }
        # waf_exclusion_policy {
        #   name = module.waf_exclusion_policy.waf_exclusion_policy_name
        #   namespace = var.namespace
        # }

      }

    }
  }

}

module "app_firewall" {
  source       = "../app_firewall"
  names        = ["app-fw-monitoring", "app-fw-blocking"]
  namespace    = var.namespace
  app_fw_count = 2

  enforcement_mode = [{ monitoring = true, blocking = false }, { monitoring = false, blocking = true }]
}




# module "custom_route_object" {
#   source    = "../custom_route_object"
#   namespace = var.namespace
#   domains = var.domains
#   lb_count = var.lb_count
# }