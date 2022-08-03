## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.datadog](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog API key | `string` | `""` | no |
| <a name="input_dd_version"></a> [dd\_version](#input\_dd\_version) | Datadog helm chart version | `string` | `"2.35.6"` | no |
| <a name="input_value_overrides"></a> [value\_overrides](#input\_value\_overrides) | A map used to feed the dynamic blocks of the datadog helm chart | `map(any)` | `{}` | no |

## Outputs

No outputs.
