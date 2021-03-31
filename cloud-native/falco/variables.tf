variable "installCRDs" {
  type    = string
  default = "true"
}

variable "project_id" {
  type = string
}

variable "product" {
  type = string
}

variable "requirements" {
  type = list(string)
}

variable "webhookurl" {
  type = string
}