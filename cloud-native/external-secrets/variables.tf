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


locals {
  validate_projectId_gcp = (var.cloud_provider == "gcp" && length(var.project_id) == 0) ? tobool("GCP provider requires the use of a project ID in this module") : true
}
