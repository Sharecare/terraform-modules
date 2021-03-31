## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 2.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 2.18.0 |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_record.toniq_api_backend](https://registry.terraform.io/providers/cloudflare/cloudflare/2.18.0/docs/resources/record) | resource |
| [cloudflare_record.toniq_console_backend](https://registry.terraform.io/providers/cloudflare/cloudflare/2.18.0/docs/resources/record) | resource |
| [cloudflare_record.toniq_minio_backend](https://registry.terraform.io/providers/cloudflare/cloudflare/2.18.0/docs/resources/record) | resource |
| [cloudflare_record.toniq_session_backend](https://registry.terraform.io/providers/cloudflare/cloudflare/2.18.0/docs/resources/record) | resource |
| [google_dns_record_set.console_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_dns_record_set.minio_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_dns_record_set.session_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_dns_record_set.toniq_api_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [helm_release.ambassador](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.secret_keys](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [local_file.certificate_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.issuer_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.ambassador_ip](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.certificate_yaml_apply](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.cf_issuer_yaml_apply](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.done](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.issuer_yaml_apply](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.sa_account](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [cloudflare_zones.doc_ai](https://registry.terraform.io/providers/cloudflare/cloudflare/2.18.0/docs/data-sources/zones) | data source |
| [google_dns_managed_zone.dns_entry](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone) | data source |
| [local_file.ambassador_ip_text](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [template_file.ambassador_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.certificate_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.issuer_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_key"></a> [cloudflare\_key](#input\_cloudflare\_key) | n/a | `string` | n/a | yes |
| <a name="input_common_name"></a> [common\_name](#input\_common\_name) | n/a | `string` | `"staging.docai.beer"` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | n/a | `string` | `"staging.docai.beer."` | no |
| <a name="input_dns_project_id"></a> [dns\_project\_id](#input\_dns\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_installCRDs"></a> [installCRDs](#input\_installCRDs) | n/a | `string` | `"true"` | no |
| <a name="input_product"></a> [product](#input\_product) | n/a | `string` | `"data-toniq"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_provder"></a> [provder](#input\_provder) | n/a | `string` | `"clouddns"` | no |
| <a name="input_requirements"></a> [requirements](#input\_requirements) | n/a | `list(string)` | n/a | yes |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | n/a | `string` | `"beer"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_done"></a> [done](#output\_done) | n/a |
