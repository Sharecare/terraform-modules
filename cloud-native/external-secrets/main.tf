resource "helm_release" "external-secrets" {

  name                  = "external-secrets"
  repository            = "https://charts.external-secrets.io"
  chart                 = "external-secrets/external-secrets"
  version               = "0.5.9"
  namespace             = var.namespace
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
    value = var.service_account_name
  }
  dynamic "set" {
    for_each = var.values_overrides
    content {
      name  = set.key
      value = set.value
    }
  }
}
