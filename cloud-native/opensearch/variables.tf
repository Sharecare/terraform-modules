
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

variable "create_snapshots" {
  type        = bool
  default     = true
  description = "determines if the job to create snapshots will be deployed"
}

variable "snapshot_bucket" {
  type        = string
  default     = "random-unique-bucket-name"
  description = "Bucket name to use to when registering a snapshot bucket"
}

variable "snapshot_type" {
  type        = string
  default     = "s3"
  description = "Type of snapshot source to use currenty only supports gcs/s3"
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