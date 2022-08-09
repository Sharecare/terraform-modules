## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_external_secrets_workload_identity"></a> [external\_secrets\_workload\_identity](#module\_external\_secrets\_workload\_identity) | terraform-google-modules/kubernetes-engine/google//modules/workload-identity | 20.0.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.external-secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.external-secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_roles"></a> [gcp\_roles](#input\_gcp\_roles) | roles to assign to the k8s service account | `list(string)` | <pre>[<br>  "roles/secretmanager.secretAccessor"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | namespace/serviceaccount where external-secrets lives | `string` | `"external-secrets"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | project id for the k8s cluster gcp | `string` | `""` | no |
| <a name="input_provider"></a> [provider](#input\_provider) | provider for the k8s cluster (gcp, aws, azure) | `string` | n/a | yes |

## Outputs

No outputs.
