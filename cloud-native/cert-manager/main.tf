resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert-manager-version
  namespace  = kubernetes_namespace.cert_manager.id
  values     = [templatefile("${path.module}/templates/values.yaml", {})]


  dynamic "set" {
    for_each = var.certmanager_value_overrides
    iterator = override
    content {
      name  = override.key
      value = override.value
    }
  }
  depends_on = [
    kubernetes_namespace.cert_manager
  ]
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    annotations = {
      name = "cert-namanger"
    }

    labels = {
      application = "cert-manager"
    }

    name = "cert-manager"
  }
}


resource "helm_release" "manifests" {
  name         = "cert-manager-manifests"
  chart        = "${path.module}/manifests"
  version      = "1.0.0"
  namespace    = "ingress"
  force_update = true
  lint         = true

  dynamic "set" {
    for_each = local.manifest_map
    content {
      name  = set.key
      value = set.value
    }
  }


  depends_on = [
    helm_release.cert_manager
  ]
}

# resource "kubernetes_manifest" "cloudflare_issuer" {
#   count    = local.has_cloudflare ? 1 : 0
#   provider = kubernetes
#   manifest = templatefile("${path.module}/manifests/issuer-cloudflare.yaml")
# }

# resource "kubernetes_manifest" "clouddns_issuer" {
#   for_each = local.clouddns_certs
#   provider = kubernetes
#   manifest = templatefile("${path.module}/manifests/issuer-clouddns.yaml", {
#     PROJECT_ID             = each.value.project
#     SERVICE_ACCOUNT_NAME   = "${google_service_account.service_account[each.key].name}.json"
#     COMMON_NAME_NORMALIZED = replace(each.key, ".", "-")
#   })
# }
# trimsuffix(join(".", formatlist("%s%s", split(".", "doc.ai"), "//")), "//")

# resource "kubernetes_manifest" "certificates" {
#   for_each = var.certificates
#   provider = kubernetes

#   manifest = templatefile("${path.module}/manifests/certificate.yaml", {
#     COMMON_NAME_NORMALIZED = replace(each.key, ".", "-")
#     COMMOM_NAME            = each.key
#     PROVIDER               = each.value.provider
#   })
#   depends_on = [
#     kubernetes_manifest.clouddns_issuer,
#     kubernetes_manifest.clouddns_issuer
#   ]
# }
