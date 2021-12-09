## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.dashboards](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.fluentd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metricbeat](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.opensearch](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map.init-opensearch-dashboards](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | cloud provider to set up infra for | `string` | `"gcp"` | no |
| <a name="input_dashboards_enabled"></a> [dashboards\_enabled](#input\_dashboards\_enabled) | Enable dashboards interface of opensearch cluster | `bool` | `false` | no |
| <a name="input_dashboards_url"></a> [dashboards\_url](#input\_dashboards\_url) | public url for dashboards interface, Only use if dashboards\_enabled=true | `string` | `""` | no |
| <a name="input_fluentd_overrides"></a> [fluentd\_overrides](#input\_fluentd\_overrides) | map of values to override fluentd values | `any` | `{}` | no |
| <a name="input_metricbeat_enabled"></a> [metricbeat\_enabled](#input\_metricbeat\_enabled) | Enable metricscraping of prometheus | `bool` | `false` | no |
| <a name="input_metricbeat_overrides"></a> [metricbeat\_overrides](#input\_metricbeat\_overrides) | map of values to override metricbeat values | `any` | `{}` | no |
| <a name="input_observability_enabled"></a> [observability\_enabled](#input\_observability\_enabled) | Create resources to enable logging/metrics/trace ingestion | `bool` | `false` | no |
| <a name="input_opensearch_dashboard_overrides"></a> [opensearch\_dashboard\_overrides](#input\_opensearch\_dashboard\_overrides) | map of values to override opensearch dashboards values | `any` | `{}` | no |
| <a name="input_opensearch_overrides"></a> [opensearch\_overrides](#input\_opensearch\_overrides) | map of values to override opensearch values | `any` | `{}` | no |
| <a name="input_pv_zones"></a> [pv\_zones](#input\_pv\_zones) | array of zones to use with regional persistant volumes | `list(any)` | `[]` | no |

## Outputs

No outputs.
