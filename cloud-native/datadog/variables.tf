variable "datadog_api_key" {
  type        = string
  default     = ""
  description = "Datadog API key"
}
variable "value_overrides" {
  description = "A map used to feed the dynamic blocks of the datadog helm chart"
  type        = map(any)
  default     = {}
}

variable "dd_version" {
  description = "Datadog helm chart version"
  type        = string
  default     = "2.35.6"
}