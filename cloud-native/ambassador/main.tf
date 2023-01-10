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

  values = [file("${path.module}/templates/values.yaml")]
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
    helm_release.manifests
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

# If these manifests change in the helm chart then update the helm chart
# version in the Chart.yaml and here in the version to force an upgrade of
# the helm chart.
resource "helm_release" "manifests" {
  name            = "ambassador-manifests"
  chart           = "${path.module}/manifests"
  version         = "2.9.5"
  namespace       = "ingress"
  force_update    = true
  lint            = true
  cleanup_on_fail = true

  dynamic "set" {
    for_each = local.tls_contexts
    content {
      name  = "tls_contexts.${set.key}"
      value = set.value
    }
  }
  # depends_on = [
  #   helm_release.crds
  # ]
}

# resource "helm_release" "crds" {
#   name             = "ambassador-crds"
#   chart            = "${path.module}/crds"
#   version          = "2.9.5"
#   create_namespace = true
#   namespace        = "emissary-system"
#   force_update     = true
#   lint             = true
#   cleanup_on_fail  = true
# }
