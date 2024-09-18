## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google | 30.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name_override"></a> [cluster\_name\_override](#input\_cluster\_name\_override) | n/a | `string` | `""` | no |
| <a name="input_default_max_pods_per_node"></a> [default\_max\_pods\_per\_node](#input\_default\_max\_pods\_per\_node) | n/a | `string` | `"20"` | no |
| <a name="input_dns_cache"></a> [dns\_cache](#input\_dns\_cache) | n/a | `bool` | `false` | no |
| <a name="input_gke_backup_agent_config"></a> [gke\_backup\_agent\_config](#input\_gke\_backup\_agent\_config) | n/a | `bool` | `false` | no |
| <a name="input_grant_registry_access"></a> [grant\_registry\_access](#input\_grant\_registry\_access) | n/a | `bool` | `false` | no |
| <a name="input_http_load_balancing"></a> [http\_load\_balancing](#input\_http\_load\_balancing) | n/a | `bool` | `false` | no |
| <a name="input_ip_range_pods"></a> [ip\_range\_pods](#input\_ip\_range\_pods) | n/a | `string` | n/a | yes |
| <a name="input_ip_range_services"></a> [ip\_range\_services](#input\_ip\_range\_services) | n/a | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `string` | `"latest"` | no |
| <a name="input_maintenance_start_time"></a> [maintenance\_start\_time](#input\_maintenance\_start\_time) | n/a | `string` | `"01:00"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | n/a | `any` | n/a | yes |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | n/a | `any` | n/a | yes |
| <a name="input_node_pools_labels"></a> [node\_pools\_labels](#input\_node\_pools\_labels) | n/a | `any` | n/a | yes |
| <a name="input_node_pools_metadata"></a> [node\_pools\_metadata](#input\_node\_pools\_metadata) | n/a | `any` | n/a | yes |
| <a name="input_node_pools_oauth_scopes"></a> [node\_pools\_oauth\_scopes](#input\_node\_pools\_oauth\_scopes) | n/a | `any` | n/a | yes |
| <a name="input_node_pools_tags"></a> [node\_pools\_tags](#input\_node\_pools\_tags) | n/a | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-central1"` | no |
| <a name="input_remove_default_node_pool"></a> [remove\_default\_node\_pool](#input\_remove\_default\_node\_pool) | n/a | `bool` | `false` | no |
| <a name="input_security_posture_vulnerability_mode"></a> [security\_posture\_vulnerability\_mode](#input\_security\_posture\_vulnerability\_mode) | n/a | `string` | `"VULNERABILITY_BASIC"` | no |
| <a name="input_subnetwork_name"></a> [subnetwork\_name](#input\_subnetwork\_name) | n/a | `any` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | n/a | `list` | <pre>[<br>  "us-central1-a",<br>  "us-central1-b",<br>  "us-central1-c"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attributes"></a> [attributes](#output\_attributes) | n/a |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | n/a |
