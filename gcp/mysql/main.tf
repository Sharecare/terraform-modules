resource "random_id" "name" {
  byte_length = 4
}

locals {
  ip_configuration = {
    ipv4_enabled        = true
    require_ssl         = false
    private_network     = null
    authorized_networks = var.authorized_networks
    allocated_ip_range  = null
  }
  read_replicas = [
    {
      name                = "0"
      zone                = "${var.region}-a"
      tier                = var.tier
      ip_configuration    = local.ip_configuration
      database_flags      = var.database_flags
      disk_autoresize     = var.disk_autoresize
      disk_size           = var.disk_size
      disk_type           = "PD_HDD"
      user_labels         = var.tags
      encryption_key_name = var.encryption_key_name
    }
  ]
}

module "mysql_db" {
  source                           = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version                          = "11.0.0"
  name                             = "${var.project_id}-mysql-${var.name}"
  database_version                 = var.mysql_version
  project_id                       = var.project_id
  availability_type                = "REGIONAL"
  region                           = var.region
  zone                             = "${var.region}-c"
  disk_size                        = var.disk_size
  tier                             = var.tier
  random_instance_name             = true
  deletion_protection              = var.deletion_protection
  read_replica_deletion_protection = var.read_replica_enabled ? var.read_replica_enabled : false
  disk_autoresize                  = var.disk_autoresize
  enable_default_user              = false
  enable_default_db                = false
  ip_configuration                 = local.ip_configuration
  database_flags                   = var.database_flags
  user_labels                      = var.tags
  backup_configuration             = var.backup_configuration

  db_name              = var.db_name
  db_charset           = var.db_charset
  db_collation         = var.db_collation
  additional_users     = length(var.additional_users) > 0 ? var.additional_users : []
  additional_databases = length(var.additional_databases) > 0 ? var.additional_databases : []


  read_replica_name_suffix = var.read_replica_enabled ? "-replica" : ""
  read_replicas            = var.read_replica_enabled ? local.read_replicas : []
}
