Project Module: Create a project under a specific project and enable a list of services

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_project_factory"></a> [project\_factory](#module\_project\_factory) | terraform-google-modules/project-factory/google | 11.3.1 |

## Resources

| Name | Type |
|------|------|
| [google_billing_account.acct](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/billing_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_network"></a> [auto\_create\_network](#input\_auto\_create\_network) | n/a | `string` | `"false"` | no |
| <a name="input_default_service_account"></a> [default\_service\_account](#input\_default\_service\_account) | Project default service account setting: can be one of delete, deprivilege, disable, or keep. | `string` | `"disable"` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | n/a | `string` | `"Doc.ai - SADA"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | folder id that this project belongs to | `any` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | organization this project belongs to (Required) | `any` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project to create | `any` | n/a | yes |
| <a name="input_project_services"></a> [project\_services](#input\_project\_services) | List of services that need to be enabled for the given project. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Id of the project created |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Name of the project created |
