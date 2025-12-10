# locals {
#   # eg 5
#   no_of_routes = sum([for domain in var.domains : len(domain)])
#   # eg [3,2]
#   no_of_domains_per_lb = [for domain in var.domains : len(domain)]
#   #

# }



# resource "volterra_route" "domain_specific_home_route" {
#   count = var.lb_count

#   name      = "home-route"
#   namespace = var.namespace

#   dynamic "routes" {


#     for_each = var.domains[count.index]

#     content {

#       # waf_type {
#       #   inherit_waf = true

#       # }

#       inherited_bot_defense_javascript_injection = true

#       match {

#         headers {

#           invert_match = false
#           name         = "Host"

#           exact = routes.value
#         }
#         http_method = "GET"

#         path {
#           prefix = "/"
#         }
#         incoming_port {
#           port = 80
#         }

#       }

#       route_destination {

#         host_rewrite = routes.value
#         # origin pool name
#         destinations {
#           cluster {
#             name      = "demo-origin"
#             namespace = "sharat-test"

#           }

#         }
#       }

#     }


#   }

# }






