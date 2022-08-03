variable "project_id" {
  type = string
}

variable "product" {
  type = string
}

variable "webhookurl" {
  type = string
}

variable "value_overrides" {
  type    = map(string)
  default = {}

}