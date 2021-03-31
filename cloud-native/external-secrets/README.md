## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_binding.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_service_account_iam_policy.admin-account-iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_policy) | resource |
| [helm_release.externalsec](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.done](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.k8_service_account](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [google_iam_policy.admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |
| [local_file.service_account_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [template_file.template_values_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster"></a> [cluster](#input\_cluster) | GCP kubernetes cluster | `string` | n/a | yes |
| <a name="input_k8_service_account"></a> [k8\_service\_account](#input\_k8\_service\_account) | service account in k8 cluster with secret access privelages | `string` | `"external-secrets"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | namespace where the external secrets in deployed | `string` | `"default"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | region where the kubernetes cluster is deployed | `string` | n/a | yes |
| <a name="input_requirements"></a> [requirements](#input\_requirements) | n/a | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_done"></a> [done](#output\_done) | n/a |
