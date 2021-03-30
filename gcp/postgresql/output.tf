
output "connection_name" {
  value = "${module.postgresql_db.instance_connection_name}"
}

output "generated_user_password" {
  value = "${module.postgresql_db.generated_user_password}"
}