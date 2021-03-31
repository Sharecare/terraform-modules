## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_postgresql_db"></a> [postgresql\_db](#module\_postgresql\_db) | GoogleCloudPlatform/sql-db/google//modules/postgresql | 4.1.0 |

## Resources

| Name | Type |
|------|------|
| [random_id.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_databases"></a> [additional\_databases](#input\_additional\_databases) | list of databases to add to the instance | `list(any)` | `[]` | no |
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | list of user to add to the database | `list(string)` | `[]` | no |
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | List of authorized pulic network that connect to the SQLDB | `list(string)` | `[]` | no |
| <a name="input_backup_location"></a> [backup\_location](#input\_backup\_location) | n/a | `string` | `"us-central1"` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Size of the SQL Storage in GB | `string` | `"50"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the project this houses | `string` | n/a | yes |
| <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version) | Version for the postgresql instance. | `string` | `"POSTGRES_9_6"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project where this mysql db needs to be created | `string` | `"serenity-stage-d334"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-central1"` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1. | `string` | `"db-custom-1-3840"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | n/a |
| <a name="output_generated_user_password"></a> [generated\_user\_password](#output\_generated\_user\_password) | n/a |
