## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.certificates](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.issuers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.cert-manager-credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.cloudflare_key](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [template_file.certificate_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ambassador_namespace"></a> [ambassador\_namespace](#input\_ambassador\_namespace) | namespace where ambassador lives | `string` | `"ingress"` | no |
| <a name="input_cert-manager-version"></a> [cert-manager-version](#input\_cert-manager-version) | Certificate version | `string` | `"1.8.0"` | no |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | map of certificate requests | `map(any)` | <pre>{<br>  "docai.beer": "cloudDNS"<br>}</pre> | no |
| <a name="input_certmanager_value_overrrides"></a> [certmanager\_value\_overrrides](#input\_certmanager\_value\_overrrides) | A map used to feed the dynamic blocks of the cert manager helm chart | `map(any)` | <pre>{<br>  "extraArgs": "{--dns01-recursive-nameservers=8.8.8.8:53,8.8.4.4:53,--dns01-recursive-nameservers-only=true}",<br>  "installCRDs": "true"<br>}</pre> | no |
| <a name="input_cloudflare_key"></a> [cloudflare\_key](#input\_cloudflare\_key) | Cloudflare API Key | `string` | n/a | yes |
| <a name="input_dns_zone_project"></a> [dns\_zone\_project](#input\_dns\_zone\_project) | GCP project ID where the DNS zone exists | `string` | `"infra-sec"` | no |
| <a name="input_issuers"></a> [issuers](#input\_issuers) | map of issuers | `map` | <pre>{<br>  "cloudDNS": {<br>    "project": "default_project_Id"<br>  },<br>  "cloudflare": {<br>    "apiTokenSecretRef": {<br>      "key": "api-token",<br>      "name": "cloudflare-api-token-secret"<br>    }<br>  }<br>}</pre> | no |

## Outputs

No outputs.
