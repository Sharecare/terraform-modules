resource "helm_release" "ambassador" {
  name             = "ambassador"
  repository       = "https://getambassador.io"
  chart            = "ambassador"
  version          = "6.6.0"
  namespace        = "ingress"
  create_namespace = var.create_namespace
  force_update     = true
  lint             = true

  values = [file("${path.module}/templates/values.yaml")]
}

resource "helm_release" "manifests" {
  name         = "ambassador-manifests"
  chart        = "${path.module}/manifests"
  version      = "1.0.0"
  namespace    = "ingress"
  force_update = true
  lint         = true

  set {
    name  = "provider"
    value = var.dns_provider
  }
  dynamic "set" {
    for_each = var.tls_contexts
    content {
      name  = "tls_contexts.${set.key}"
      value = set.value
    }
  }
  depends_on = [
    helm_release.ambassador
  ]
}