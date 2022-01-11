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
| [helm_release.elasticsearch](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kibana](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metricbeat](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_storage_class.elastic](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kibana_enabled"></a> [kibana\_enabled](#input\_kibana\_enabled) | Enable kibana interface of elasticsearch cluster | `bool` | `false` | no |
| <a name="input_kibana_url"></a> [kibana\_url](#input\_kibana\_url) | public url for kibana interface, Only use if kibana\_enabled=true | `string` | `""` | no |
| <a name="input_metricbeat_enabled"></a> [metricbeat\_enabled](#input\_metricbeat\_enabled) | Enable metricscraping of prometheus | `bool` | `false` | no |

## Outputs

No outputs.
