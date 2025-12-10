variable "lb_count" {
  type = number
}
variable "namespace" {
  type = string
}
variable "tenant_url" {
  type = string
}
variable "api_token" {
  type      = string
  sensitive = true
}

variable "labels" {
  type = map(string)
}

variable "domains" {
  type = list(list(string))
}

# variable "cdn_cname" {
#   type = list(string)
# }

# variable "cdn_domain" {
#   type = list(string)
# }

# variable "origin_pool_name_list" {
#   type = list(string)
# }
