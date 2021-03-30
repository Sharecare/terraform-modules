

variable "postgresql_version" {
  description = "Version for the postgresql instance."
  default     = "POSTGRES_9_6"
  type        = "string"
}

variable "project_id" {
  description = "Project where this mysql db needs to be created"
  type        = "string"
  default     = "serenity-stage-d334"
}

variable "region" {
  default = "us-central1"
  type    = "string"
}

variable "backup_location" {
  default = "us-central1"
  type    = "string"
}

variable "authorized_networks" {
  type = "list"
  default = []
  description = "List of authorized pulic network that connect to the SQLDB"
}

variable "additional_users" {
  type = "list"
  default = []
  description = "list of user to add to the database"
}

variable additional_databases {
  type = list
  default = []
  description = "list of databases to add to the instance"
}

variable "disk_size" {
  default     = "50"
  type        = "string"
  description = "Size of the SQL Storage in GB"
}

variable "tier" {
  default     = "db-custom-1-3840"
  type        = "string"
  description = "available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1."
}

variable name {
  type = string
  description = "Name of the project this houses"
}
