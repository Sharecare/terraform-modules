
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

variable "observability_enabled" {
  type        = bool
  default     = false
  description = "Create resources to enable logging/metrics/trace ingestion"
}

variable "pv_zones" {
  type        = list(any)
  default     = []
  description = "array of zones to use with regional persistant volumes"
}

variable "opensearch_overrides" {
  type        = any
  description = "map of values to override opensearch values"
  default     = {}
}

variable "opensearch_dashboard_overrides" {
  type        = any
  description = "map of values to override opensearch dashboards values"
  default     = {}
}

variable "metricbeat_overrides" {
  type        = any
  description = "map of values to override metricbeat values"
  default     = {}
}

variable "fluentd_overrides" {
  type        = any
  description = "map of values to override fluentd values"
  default     = {}
}