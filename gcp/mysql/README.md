## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mysql_db"></a> [mysql\_db](#module\_mysql\_db) | GoogleCloudPlatform/sql-db/google//modules/mysql | 10.0.0 |

## Resources

| Name | Type |
|------|------|
| [random_id.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_databases"></a> [additional\_databases](#input\_additional\_databases) | list of databases to add to the database cluster | `list(any)` | `[]` | no |
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | list of user to add to the database | `list(any)` | `[]` | no |
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | List of authorized pulic network that connect to the SQLDB | `list(any)` | `[]` | no |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | n/a | `map(any)` | <pre>{<br>  "binary_log_enabled": true,<br>  "enabled": true,<br>  "location": null,<br>  "retained_backups": null,<br>  "retention_unit": null,<br>  "start_time": "12:13",<br>  "transaction_log_retention_days": null<br>}</pre> | no |
| <a name="input_db_charset"></a> [db\_charset](#input\_db\_charset) | n/a | `string` | `"utf8mb4"` | no |
| <a name="input_db_collation"></a> [db\_collation](#input\_db\_collation) | n/a | `string` | `"utf8mb4_general_ci"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | n/a | `string` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | n/a | `bool` | n/a | yes |
| <a name="input_disk_autoresize"></a> [disk\_autoresize](#input\_disk\_autoresize) | n/a | `bool` | `true` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Size of the SQL Storage in GB | `string` | `"250"` | no |
| <a name="input_enable_failover_replica"></a> [enable\_failover\_replica](#input\_enable\_failover\_replica) | flag to enable failover replica or not | `string` | `"true"` | no |
| <a name="input_encryption_key_name"></a> [encryption\_key\_name](#input\_encryption\_key\_name) | Disk Encryption Key name (required if read replica is cross regional) | `string` | `null` | no |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | Version for the mysql instance. | `string` | `"MYSQL_5_7"` | no |
| <a name="input_name"></a> [name](#input\_name) | name to append to the cluster name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project where this mysql db needs to be created | `string` | `"serenity-stage-d334"` | no |
| <a name="input_read_replica_enabled"></a> [read\_replica\_enabled](#input\_read\_replica\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_read_replicas"></a> [read\_replicas](#input\_read\_replicas) | n/a | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-central1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1. | `string` | `"db-n1-standard-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | n/a |
| <a name="output_generated_user_password"></a> [generated\_user\_password](#output\_generated\_user\_password) | n/a |
| <a name="output_server_cert"></a> [server\_cert](#output\_server\_cert) | n/a |
