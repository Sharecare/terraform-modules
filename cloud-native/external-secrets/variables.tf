variable "name" {
  type        = string
  description = "namespace/serviceaccount where external-secrets lives"
  default     = "external-secrets"
}

variable "service_account_name" {
  type        = string
  description = "name of the k8s service account running with secret access privelages Required for external secrets"
}

variable "project_id" {
  type        = string
  description = "project id for the k8s cluster gcp"
  default     = ""
}

variable "provider" {
  type        = string
  description = "provider for the k8s cluster (gcp, aws, azure)"
}

locals {
   validate_projectId_gcp = (var.provider == "gcp" && length(var.project_id) == 0) ? tobool("GCP provider requires the use of a project ID in this module") : true
}
