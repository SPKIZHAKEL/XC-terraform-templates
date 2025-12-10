# data volterra_virtual_host_dns_info "lb_info" {
#     for_each = var.domains
#     namespace = var.namespace
#     name = "vh-1"
# }

locals {
  all_lbs = jsondecode(data.http.lb_list.response_body)
}

data "http" "lb_list" {
  url = "${var.tenant_url}/config/namespaces/${var.namespace}/cdn_loadbalancers?report_fields=host_name"
  # Optional request headers
  request_headers = {
    Accept        = "application/json"
    Authorization = "APIToken ${var.api_token}"
  }
}