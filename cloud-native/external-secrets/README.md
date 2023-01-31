## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.4.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.7.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_external_secrets_namespace_sa"></a> [external\_secrets\_namespace\_sa](#module\_external\_secrets\_namespace\_sa) | terraform-google-modules/kubernetes-engine/google//modules/workload-identity | 24.1.0 |
| <a name="module_external_secrets_sa"></a> [external\_secrets\_sa](#module\_external\_secrets\_sa) | terraform-google-modules/kubernetes-engine/google//modules/workload-identity | 24.1.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.aws_secret_store](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.crds](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.gcp_secret_store](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.external_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubectl_file_documents.crds](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud Provider being used. Available values are gcp, aws | `string` | `"gcp"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | GCP kubernetes cluster | `string` | n/a | yes |
| <a name="input_gke_location"></a> [gke\_location](#input\_gke\_location) | region or zone where the kubernetes cluster is deployed | `string` | n/a | yes |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | n/a | `string` | `"0.7.2"` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | List of namespaces to create a secret store in | `list(string)` | n/a | yes |
| <a name="input_overrides"></a> [overrides](#input\_overrides) | n/a | `map(any)` | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project | `string` | n/a | yes |

## Outputs

No outputs.
