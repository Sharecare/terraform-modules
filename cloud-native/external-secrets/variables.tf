variable "helm_version" {
  type    = string
  default = "0.7.2"
}

variable "cloud_provider" {
  type        = string
  description = "Cloud Provider being used. Available values are gcp, aws"
  default     = "gcp"
}

variable "namespaces" {
  type        = list(string)
  description = "List of namespaces to create a secret store in"
}


variable "project_id" {
  type        = string
  description = "GCP project"
}

variable "cluster_name" {
  type        = string
  description = "GCP kubernetes cluster "
}

variable "overrides" {
  type = map(any)
  default = {
  }
}


variable "gke_location" {
  type        = string
  description = "region or zone where the kubernetes cluster is deployed"
}
