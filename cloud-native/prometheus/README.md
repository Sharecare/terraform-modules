## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_domains"></a> [allowed\_domains](#input\_allowed\_domains) | oauth allowed domains not required if grafana dashboard is off | `string` | `"doc.ai"` | no |
| <a name="input_google_client_id"></a> [google\_client\_id](#input\_google\_client\_id) | oauth google client id not required if grafana dashboard is off | `string` | `""` | no |
| <a name="input_google_client_secret"></a> [google\_client\_secret](#input\_google\_client\_secret) | oauth google client secret not required if grafana dashboard is off | `string` | `""` | no |
| <a name="input_grafana_enabled"></a> [grafana\_enabled](#input\_grafana\_enabled) | flag to turn grafana dashboard on/off | `bool` | `false` | no |
| <a name="input_grafana_url"></a> [grafana\_url](#input\_grafana\_url) | public urls not required if grafana dashboard is off | `string` | `""` | no |

## Outputs

No outputs.
