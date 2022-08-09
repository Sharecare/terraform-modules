resource "helm_release" "external-secrets" {
  provider              = helm
  name                  = var.name
  repository            = "https://charts.external-secrets.io"
  chart                 = "external-secrets/external-secrets"
  version               = "0.5.9"
  namespace             = kubernetes_namespace.external-secrets.id
  create_namespace      = true
  wait                  = true
  lint                  = true
  render_subchart_notes = true
  cleanup_on_fail       = true

  values = [file("${path.module}/templates/values.yaml")]

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = var.provider == "gcp" ? module.external_secrets_workload_identity[0].k8s_service_account_name : "external-secrets-aws"
  }

  dynamic "set" {
    for_each = var.values_overrides
    content {
      name  = set.key
      value = set.value
    }
  }
}
