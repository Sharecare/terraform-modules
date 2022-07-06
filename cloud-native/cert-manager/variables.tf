variable "ambassador_namespace" {
  description = "namespace where ambassador lives"
  type        = string
  default     = "ingress"
}

variable "certificates" {
  description = "map of certificate requests"
  type        = map(any)
  default = {
    "docai.beer" = {
      provider = "clouddns"
      project  = "doc-ai-infra-sec"
    }

    "harbor.docai.beer" = {
      provider = "clouddns"
      project  = "infra-sec"
    }

    "doc.ai" = {
      provider = "cloudflare"
      project  = ""
    }
  }
}
variable "cert-manager-version" {
  description = "Certificate version"
  type        = string
  default     = "1.8.0"
}

variable "certmanager_value_overrides" {
  description = "A map used to feed the dynamic blocks of the cert manager helm chart"
  type        = map(any)
  default = {
    "installCRDs" = "true"
    "extraArgs"   = "{--dns01-recursive-nameservers=8.8.8.8:53,8.8.4.4:53,--dns01-recursive-nameservers-only=true}"
  }
}

variable "cloudflare_key" {
  description = "Cloudflare API Key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "create_certmanager_namespace" {
  description = "Create namespace true if this is a fresh install otherwise use default false"
  default     = false
}

variable "create_ingress_namespace" {
  description = "Create namespace true if this is a fresh install otherwise use default false"
  default     = false
}

locals {
  common_name_provider_map = { for k, v in var.certificates : k => v["provider"] }
  has_cloudflare           = contains(values(local.common_name_provider_map), "cloudflare")
  clouddns_certs           = { for k, v in var.certificates : k => v if v["provider"] == "clouddns" }

  # tflint-ignore: terraform_unused_declarations
  validate_cloudflare_key_required = (local.has_cloudflare && length(var.cloudflare_key) == 0) ? tobool("cloudflare_key must be set to have a valid issuer.") : true
  # validate that the cloudflare_key var is set if certificates has a common name that belongs to cloudflare

  manifests_array = flatten([
    for domain, config in var.certificates : {
      domain               = domain
      provider             = lookup(config, "provider", "clouddns")
      project              = lookup(config, "project", "")
      service_account_name = try(google_service_account.service_account[domain].name, "")
    }
  ])

  manifest_helm_set = flatten([
    for k, v in local.manifests_array :
    {
      "certificates[${k}].common_name"          = replace(v["domain"], ".", "!")
      "certificates[${k}].provider"             = v["provider"]
      "certificates[${k}].project"              = v["project"]
      "certificates[${k}].service_account_name" = "${v["service_account_name"]}.json"
      "providers[${k}]"                         = v["provider"]
    }
  ])
  manifest_map = merge(local.manifest_helm_set...)
}
