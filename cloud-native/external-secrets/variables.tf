
variable "project_id" {
  type        = string
  description = "GCP project"
}

variable "cluster" {
  type        = string
  description = "GCP kubernetes cluster "
}



variable "region" {
  type        = string
  description = "region where the kubernetes cluster is deployed"
}

variable "requirements" {
  type = list(string)
}

variable "k8_service_account" {
  type        = string
  description = "service account in k8 cluster with secret access privelages "
  default     = "external-secrets"
}

variable "namespace" {
  type        = string
  description = "namespace where the external secrets in deployed"
  default     = "default"
}
