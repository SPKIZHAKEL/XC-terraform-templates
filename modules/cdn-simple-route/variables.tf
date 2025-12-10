variable "lb_count" {
  type = number
}
variable "namespace" {
  type = string
}

#enter all domains per lb
variable "domains" {
  type = list(list(string))
}

variable "cdn_domains" {
  type = list(string)
}