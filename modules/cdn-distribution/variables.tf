
variable "namespace" {
  type = string
}

variable "labels" {
  type = map(string)
}

variable "domains" {
  type = list(string)
}
variable "tenant_url" {
  type = string
}
variable "api_token" {
  type      = string
  sensitive = true
}