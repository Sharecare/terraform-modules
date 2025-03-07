variable "project_id" {}
variable "subnetwork_name" {}
variable "network_name" {}


variable "region" {
  default = "us-central1"
}

variable "zones" {
  default = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "http_load_balancing" {
  default = false
}

variable "remove_default_node_pool" {
  default = false
}

variable "grant_registry_access" {
  type    = bool
  default = false
}

variable "node_pools" {}

variable "node_pools_oauth_scopes" {}

variable "node_pools_labels" {}

variable "node_pools_metadata" {}

variable "node_pools_tags" {}

variable "kubernetes_version" {
  default = "latest"
}

variable "default_max_pods_per_node" {
  default = "20"
}

variable "dns_cache" {
  type    = bool
  default = false
}

variable "maintenance_start_time" {
  default = "01:00"
}

variable "gke_backup_agent_config" {
  type    = bool
  default = false
}

variable "ip_range_pods" {
  type = string
}

variable "ip_range_services" {
  type = string
}

variable "cluster_name_override" {
  type    = string
  default = ""
}

variable "security_posture_vulnerability_mode" {
  type    = string
  default = "VULNERABILITY_BASIC"
}

variable "cluster_dns_provider" {
  type    = string
  default = "PROVIDER_UNSPECIFIED"
}

variable "cluster_dns_scope" {
  type    = string
  default = "DNS_SCOPE_UNSPECIFIED"
}

variable "enable_vertical_pod_autoscaling" {
  type = bool
  default = false
}

variable "cluster_autoscaling" {
  description = "Cluster autoscaling configuration"
  type = object({
    enabled       = bool
    auto_repair   = bool
    auto_upgrade  = bool

    min_cpu_cores = number
    max_cpu_cores = number
    min_memory_gb = number
    max_memory_gb = number

    gpu_resources = list(object({
      resource_type = string
      minimum       = number
      maximum       = number
    }))

    autoscaling_profile = string
  })
  default = {
    enabled       = true
    auto_repair   = true
    auto_upgrade  = true

    // For Java/NodeJS workloads on n2-standard-4 (4 CPU, 16GB)
    min_cpu_cores = 4
    max_cpu_cores = 64  // Allow scaling to support multiple applications
    min_memory_gb = 16
    max_memory_gb = 256 // Java applications can be memory hungry

    gpu_resources = []  // No GPUs needed for Java/NodeJS

    autoscaling_profile = "BALANCED"
  }
}

locals {
  cluster_name = var.cluster_name_override != "" ? var.cluster_name_override : "${var.project_id}-cluster"
}