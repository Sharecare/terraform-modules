
output "server_cert" {
  value = "${module.mysql_db.instance_server_ca_cert}"
}

output "connection_name" {
  value = "${module.mysql_db.instance_connection_name}"
}

output "generated_user_password" {
  value = "${module.mysql_db.generated_user_password}"
}