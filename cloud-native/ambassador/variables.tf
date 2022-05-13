variable "dns_provider" {
  type        = string
  default     = "clouddns"
  description = "DNS provider for cert-manager issuer; either clouddns or cloudflare by default"
}

variable "tls_contexts" {
  type        = map(string)
  description = "Map from TLSContext name (all must be unique) to domain name for ambassador/emissary to host"
}
