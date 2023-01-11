resource "helm_release" "ambassador" {
  name                  = "ambassador"
  repository            = "https://getambassador.io"
  chart                 = "emissary-ingress"
  version               = "8.4.0"
  namespace             = "ingress"
  create_namespace      = var.create_namespace ? "false" : "true"
  force_update          = true
  lint                  = true
  render_subchart_notes = true
  cleanup_on_fail       = true

  values = [file("${path.module}/templates/values.tftpl")]
  dynamic "set" {
    for_each = var.ambassador_overrides
    content {
      name  = set.key
      value = set.value
    }
  }
  set {
    name  = "service.externalTrafficPolicy"
    value = var.external_traffic_policy
  }
  depends_on = [
    kubernetes_namespace.ingress,
#    kubernetes_manifest.crds
  ]
}

resource "kubernetes_namespace" "ingress" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = {
      name = "ingress"
    }

    labels = {
      application = "ambassador"
    }
    name = "ingress"
  }
}
