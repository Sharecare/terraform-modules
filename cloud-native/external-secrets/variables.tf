variable "name" {
  type        = string
  description = "namespace/serviceaccount where external-secrets lives"
  default     = "external-secrets"
}

variable "project_id" {
  type        = string
  description = "project id for the k8s cluster gcp"
  default     = ""
}

variable "values_overrides" {
  type        = map(any)
  description = "values overrides for the external-secrets chart"
  default     = {}
}


variable "cloud_provider" {
  type        = string
  description = "provider for the k8s cluster (gcp, aws, azure)"
}

variable "gcp_roles" {
  type        = list(string)
  description = "roles to assign to the k8s service account"
  default = [
    "roles/secretmanager.secretAccessor",
  ]
}

variable "create_service_account_secret" {
  type        = bool
  description = "Create a secret for the service account if kubernetes version is >= 1.24"
}


locals {
  validate_projectId_gcp = (var.cloud_provider == "gcp" && length(var.project_id) == 0) ? tobool("GCP provider requires the use of a project ID in this module") : true
}
