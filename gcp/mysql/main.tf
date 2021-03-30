resource "random_id" "name" {
  byte_length = 4
}

module "mysql_db" {
  source           = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version = "3.2.0"
  name             = "${var.project_id}-sql-${random_id.name.hex}"
  database_version = "${var.mysql_version}"
  project_id       = "${var.project_id}"
  region           = "${var.region}"
  zone             = "c"
  disk_size        = "${var.disk_size}"
  tier             = "${var.tier}"

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = false
    authorized_networks = "${var.authorized_networks}"
  }

  additional_users = "${var.additional_users}"

  backup_configuration = {
    binary_log_enabled = true
    enabled            = true
    start_time         = "12:00"
  }
  database_flags = [
    {
      name  = "log_bin_trust_function_creators"
      value = "on"
    },
  ]

  failover_replica           = "${var.enable_failover_replica}"
  failover_replica_disk_size = "${var.disk_size}"
  failover_replica_tier      = "${var.tier}"
  failover_replica_zone      = "c"
  failover_replica_configuration = "${var.failover_replica_configuration}"
}
