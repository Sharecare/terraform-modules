resource "helm_release" "ambassador" {
  name                  = "ambassador"
  repository            = "https://getambassador.io"
  chart                 = "emissary-ingress"
  version               = "8.9.1"
  namespace             = "ingress"
  create_namespace      = var.create_namespace ? "false" : "true"
  force_update          = true
  lint                  = true
  render_subchart_notes = true
  cleanup_on_fail       = false

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

# If these CRDs change in the helm chart then update the helm chart
# version in the Chart.yaml and here in the version to force an upgrade of
# the helm chart.  Try to keep the version close to the CRD version.
resource "helm_release" "crds" {
  name            = "ambassador-crds"
  chart           = "${path.module}/crds"
  version         = "3.12.1"
  namespace       = "emissary-system"
  create_namespace = true
  force_update    = true
  lint            = true
  cleanup_on_fail = true
}

locals {
  manifests_array = flatten([
    for domain, config in var.tls_contexts : {
      domain               = domain
      provider             = lookup(config, "provider", "clouddns")
      project              = lookup(config, "project", "")
    }
  ])

  manifest_helm_set = flatten([
    for k, v in local.manifests_array :
    {
      "tls_contexts[${k}].common_name"          = replace(v["domain"], ".", "!")
      "tls_contexts[${k}].provider"             = v["provider"]
      "tls_contexts[${k}].project"              = v["project"]
    }
  ])
  manifest_map = merge(local.manifest_helm_set...)
}

# If these manifests change in the helm chart then update the helm chart
# version in the Chart.yaml and here in the version to force an upgrade of
# the helm chart.
resource "helm_release" "manifests" {
  name            = "ambassador-manifests"
  chart           = "${path.module}/manifests"
  version         = "2.9.6"
  namespace       = "ingress"
  force_update    = true
  lint            = true
  cleanup_on_fail = true

  dynamic "set" {
    for_each = local.manifest_map
    content {
      name  = set.key
      value = set.value
    }
  }
  depends_on = [
    kubernetes_namespace.ingress,
    helm_release.crds
  ]
}

