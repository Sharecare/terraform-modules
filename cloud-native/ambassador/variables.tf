variable "tls_contexts" {
  description = "tls context map same contract as cert-manager"
  default = {
    "docai.beer" = {
      provider = "clouddns"
      project  = "doc-ai-infra-sec"
    }
  }
}

locals {
  tls_contexts = { for k, v in var.tls_contexts : replace(k, ".", "-") => v.provider }
}