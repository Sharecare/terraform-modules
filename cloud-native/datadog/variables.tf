variable datadog_api_key {
  type        = string
  default     = ""
  description = "Datadog API key"
}

variable requirements {
  type        = list
  default     = []
  description = "List of module deps"
}
