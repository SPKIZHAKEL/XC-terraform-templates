locals {
  cdn_domains = var.cdn_domains

  # eg 5
  #   no_of_routes = sum([for domain in var.domains : len(domain)])
  # eg [3,2] [0,1,2,3,4] len-
  #   no_of_domains_per_lb = [for domain in var.domains : len(domain)]
  cdn_origin_pool_names = [for domain in local.cdn_domains : "${split(".", domain)[0]}"]


}

resource "volterra_route" "cdn-simple-soute" {
  count     = var.lb_count
  name      = "cdn-route"
  namespace = var.namespace
  dynamic "routes" {
    for_each = var.domains[count.index]
    content {
      match {
        http_method = "GET"
        path {
          regex = ".*\\.(js|css|jpe?g|png|gif|webp|svg|woff2?|eot|ttf|otf|docx?|rtf|txt|pdf|mp3|wav|aac|flac|ogg|m4a|mp4|avi|wmv|mov|flv|mkv|webm|mpe?g)$"
        }
        incoming_port {
          port = 443
        }
        headers {
          name  = "Host"
          exact = routes.value
        }

      }
      route_destination {
        host_rewrite = "cdn-${routes.value}"
        destinations {
          cluster {
            namespace = var.namespace
            name      = local.cdn_origin_pool_names[index(local.cdn_domains, "cdn-${routes.value}")]
          }
        }
      }
      waf_exclusion_policy {
        name      = module.waf_exclusion_policy.waf_exclusion_policy_name
        namespace = var.namespace
      }
    }
  }

}


# module "waf_exclusion_policy" {
#   source    = "../waf_exclusion_policy"
#   namespace = var.namespace

# }

