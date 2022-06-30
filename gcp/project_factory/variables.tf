variable "org_id" {
  description = "organization this project belongs to (Required)"
}

variable "project_name" {
  description = "Name of the project to create"
}
variable "project_services" {
  description = "List of services that need to be enabled for the given project."
}
variable "folder_id" {
  description = "folder id that this project belongs to"
}
variable "auto_create_network" {
  default = "false"
}

variable "default_service_account" {
  default     = "disable"
  description = "Project default service account setting: can be one of delete, deprivilege, disable, or keep."
}

variable "display_name" {
  default = "Doc.ai - SADA"
}

variable "labels" {
  description = "Map of labels for billing"
  default = {
    "project_owner" = "infra"
  }
}