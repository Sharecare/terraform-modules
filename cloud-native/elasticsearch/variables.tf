variable "metricbeat_enabled" {
  type        = bool
  default     = false
  description = "Enable metricscraping of prometheus"
}

variable "kibana_enabled" {
  type        = bool
  default     = false
  description = "Enable kibana interface of elasticsearch cluster"
}

variable "kibana_url" {
  type        = string
  default     = ""
  description = "public url for kibana interface, Only use if kibana_enabled=true"
}