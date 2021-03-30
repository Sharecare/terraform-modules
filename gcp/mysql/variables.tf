

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
  type = list
  default = []
  description = "List of authorized pulic network that connect to the SQLDB"
}

variable "additional_users" {
  type = list
  default = []
  description = "list of user to add to the database"
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

variable "failover_replica_configuration" {
  default = {
    dump_file_path            = null
    connect_retry_interval    = 5
    ca_certificate            = null
    client_certificate        = null
    client_key                = null
    failover_target           = null
    master_heartbeat_period   = null
    password                  = null
    ssl_cipher                = null
    username                  = null
    verify_server_certificate = null
  }
}

