locals {
  all_lbs = jsondecode(data.http.lb_list.response_body)
}

data "volterra_http_loadbalancer_state" "cert_info" {
  count     = var.lb_count
  name      = "tf-demo-lb-${count.index}"
  namespace = var.namespace
}

data "http" "lb_list" {
  url = "${var.tenant_url}/config/namespaces/${var.namespace}/http_loadbalancers"
  # Optional request headers
  request_headers = {
    Accept        = "application/json"
    Authorization = "APIToken ${var.api_token}"
  }
}

