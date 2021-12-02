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
| [kubernetes_storage_class.opensearch](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [kubernetes_storage_class.opensearch-aws](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | cloud provider to set up infra for | `string` | `"gcp"` | no |
| <a name="input_dashboards_enabled"></a> [dashboards\_enabled](#input\_dashboards\_enabled) | Enable dashboards interface of opensearch cluster | `bool` | `false` | no |
| <a name="input_dashboards_url"></a> [dashboards\_url](#input\_dashboards\_url) | public url for dashboards interface, Only use if dashboards\_enabled=true | `string` | `""` | no |
| <a name="input_metricbeat_enabled"></a> [metricbeat\_enabled](#input\_metricbeat\_enabled) | Enable metricscraping of prometheus | `bool` | `false` | no |

## Outputs

No outputs.
