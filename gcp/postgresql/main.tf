resource "random_id" "name" {
  byte_length = 4
}

module "postgresql_db" {
  source            = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version           = "10.0.0"
  name              = "${var.project_id}-sql-${var.name}-${random_id.name.hex}"
  database_version  = var.postgresql_version
  project_id        = var.project_id
  region            = var.region
  zone              = var.zone
  disk_size         = var.disk_size
  tier              = var.tier
  availability_type = "REGIONAL"

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = false
    authorized_networks = var.authorized_networks
    allocated_ip_range  = null
  }

  additional_databases = var.additional_databases
  additional_users     = var.additional_users
  # attributes "retained_backups", "retention_unit", and "transaction_log_retention_days" are required.

  backup_configuration = {
    point_in_time_recovery_enabled = true
    enabled                        = true
    start_time                     = "12:00"
    location                       = var.backup_location
    retained_backups               = null
    retention_unit                 = null
    transaction_log_retention_days = null
  }
}
