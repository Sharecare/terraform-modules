## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.5.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.manifests](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.rapid7](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.r7_key](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [google_secret_manager_secret_version.rapid7](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/secret_manager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_rapid7_overrides"></a> [rapid7\_overrides](#input\_rapid7\_overrides) | map overrides to r7 helm deployment. At this time only cluster name is required | `map(any)` | n/a | yes |

## Outputs

No outputs.
