

variable "mysql_version" {
  description = "Version for the mysql instance."
  default     = "MYSQL_5_7"
  type        = string
}

variable "project_id" {
  description = "Project where this mysql db needs to be created"
  type        = string
  default     = "serenity-stage-d334"
}

variable "region" {
  default = "us-central1"
  type    = string
}

variable "authorized_networks" {
  type        = list(any)
  default     = []
  description = "List of authorized pulic network that connect to the SQLDB"
}

variable "additional_users" {
  type        = list(any)
  default     = []
  description = "list of user to add to the database"
}

variable "additional_databases" {
  type        = list(any)
  default     = []
  description = "list of databases to add to the database cluster"
}

variable "enable_failover_replica" {
  default     = "true"
  type        = string
  description = "flag to enable failover replica or not"
}

variable "disk_size" {
  default     = "250"
  type        = string
  description = "Size of the SQL Storage in GB"
}

variable "tier" {
  default     = "db-n1-standard-1"
  type        = string
  description = "available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1."
}

variable "deletion_protection" {
  type = bool
}

variable "disk_autoresize" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "db_name" {
  type = string
}

variable "db_charset" {
  type    = string
  default = "utf8mb4"
}

variable "db_collation" {
  type    = string
  default = "utf8mb4_general_ci"
}

variable "name" {
  type        = string
  description = "name to append to the cluster name"
}

variable "read_replicas" {
  type    = list(any)
  default = []
}

variable "read_replica_enabled" {
  type    = bool
  default = false
}

variable "backup_configuration" {
  type = map(any)
  default = {
    binary_log_enabled = true
    enabled            = true
    start_time         = "12:13"
    location           = null
  }
}
