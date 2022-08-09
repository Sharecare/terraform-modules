variable "namespace" {
  type        = string
  description = "namespace where the external secrets in deployed"
  default     = "external-secrets"
}

variable "service_account_name" {
  type        = string
  description = "name of the k8s service account running with secret access privelages Required for external secrets"
}