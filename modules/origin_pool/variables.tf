variable "lb_count" {
  type = number
}
variable "namespace" {
  type = string
}

variable "cdn_domain" {
  type = list(string)
}
variable "cdn_cname" {
  type = list(string)
}
variable "labels" {
  type = map(string)
}