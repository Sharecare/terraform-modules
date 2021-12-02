
variable "metricbeat_enabled" {
  type        = bool
  default     = false
  description = "Enable metricscraping of prometheus"
}

variable "dashboards_enabled" {
  type        = bool
  default     = false
  description = "Enable dashboards interface of opensearch cluster"
}

variable "dashboards_url" {
  type        = string
  default     = ""
  description = "public url for dashboards interface, Only use if dashboards_enabled=true"
}

variable "cloud_provider" {
  type        = string
  default     = "gcp"
  description = "cloud provider to set up infra for"
}
