variable "rapid7_overrides" {
  description = "map overrides to r7 helm deployment. At this time only cluster name is required"
  type        = map(any)
}
