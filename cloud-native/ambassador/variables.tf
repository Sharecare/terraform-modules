variable "dns_provider" {
  type    = string
  default = "clouddns"
}

variable "tls_contexts" {
  type = map(string)
}