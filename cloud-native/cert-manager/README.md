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
| [google_project_iam_member.iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.manifests](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.cloudflare_key](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.dns_service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ambassador_namespace"></a> [ambassador\_namespace](#input\_ambassador\_namespace) | namespace where ambassador lives | `string` | `"ingress"` | no |
| <a name="input_cert-manager-version"></a> [cert-manager-version](#input\_cert-manager-version) | Certificate version | `string` | `"1.8.0"` | no |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | map of certificate requests | `map(any)` | <pre>{<br>  "doc.ai": {<br>    "project": "",<br>    "provider": "cloudflare"<br>  },<br>  "docai.beer": {<br>    "project": "doc-ai-infra-sec",<br>    "provider": "clouddns"<br>  },<br>  "harbor.docai.beer": {<br>    "project": "infra-sec",<br>    "provider": "clouddns"<br>  }<br>}</pre> | no |
| <a name="input_certmanager_value_overrides"></a> [certmanager\_value\_overrides](#input\_certmanager\_value\_overrides) | A map used to feed the dynamic blocks of the cert manager helm chart | `map(any)` | <pre>{<br>  "extraArgs": "{--dns01-recursive-nameservers=8.8.8.8:53,8.8.4.4:53,--dns01-recursive-nameservers-only=true}",<br>  "installCRDs": "true"<br>}</pre> | no |
| <a name="input_cloudflare_key"></a> [cloudflare\_key](#input\_cloudflare\_key) | Cloudflare API Key | `string` | `""` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create namespace true if this is a fresh install otherwise use default false | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sa"></a> [sa](#output\_sa) | n/a |