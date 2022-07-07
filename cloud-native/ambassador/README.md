## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.ambassador](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.manifests](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ambassador_overrides"></a> [ambassador\_overrides](#input\_ambassador\_overrides) | n/a | `map` | `{}` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | create ingress namespace? set to true if installing ambassador without Certmanager | `bool` | `false` | no |
| <a name="input_tls_contexts"></a> [tls\_contexts](#input\_tls\_contexts) | tls context map same contract as cert-manager | `map` | <pre>{<br>  "docai.beer": {<br>    "project": "doc-ai-infra-sec",<br>    "provider": "clouddns"<br>  }<br>}</pre> | no |

## Outputs

No outputs.
