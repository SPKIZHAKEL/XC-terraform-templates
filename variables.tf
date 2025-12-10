variable "api_token" {
  type      = string
  sensitive = true
}

variable "tenant_url" {
  type = string
}

variable "labels" {
  type = map(string)
}

variable "namespace" {
  type = string
}

variable "lb_count" {
  type = number
}

variable "domains" {
type=list(list(string))
}

variable "cdn_domains" {
  type = list(string)
}