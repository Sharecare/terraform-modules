## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mysql_db"></a> [mysql\_db](#module\_mysql\_db) | GoogleCloudPlatform/sql-db/google//modules/mysql | 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [random_id.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | list of user to add to the database | `list(any)` | `[]` | no |
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | List of authorized pulic network that connect to the SQLDB | `list(any)` | `[]` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Size of the SQL Storage in GB | `string` | `"250"` | no |
| <a name="input_enable_failover_replica"></a> [enable\_failover\_replica](#input\_enable\_failover\_replica) | flag to enable failover replica or not | `string` | `"true"` | no |
| <a name="input_failover_replica_configuration"></a> [failover\_replica\_configuration](#input\_failover\_replica\_configuration) | n/a | `map` | <pre>{<br>  "ca_certificate": null,<br>  "client_certificate": null,<br>  "client_key": null,<br>  "connect_retry_interval": 5,<br>  "dump_file_path": null,<br>  "failover_target": null,<br>  "master_heartbeat_period": null,<br>  "password": null,<br>  "ssl_cipher": null,<br>  "username": null,<br>  "verify_server_certificate": null<br>}</pre> | no |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | Version for the mysql instance. | `string` | `"MYSQL_5_7"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project where this mysql db needs to be created | `string` | `"serenity-stage-d334"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-central1"` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1. | `string` | `"db-n1-standard-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | n/a |
| <a name="output_generated_user_password"></a> [generated\_user\_password](#output\_generated\_user\_password) | n/a |
| <a name="output_server_cert"></a> [server\_cert](#output\_server\_cert) | n/a |
