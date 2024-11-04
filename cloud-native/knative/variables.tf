variable "project_id" {
  type = string
}

variable "product" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "kourier_pdb_min_available" {
  type    = number
  default = 0
}

variable "activator_pdb_min_available" {
  type    = number
  default = 0
}

variable "webhook_pdb_min_available" {
  type    = number
  default = 0
}

variable "eventing_webhook_min_available" {
  type    = number
  default = 0
}

variable "value_overrides" {
  type    = map(string)
  default = {}
}