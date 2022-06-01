resource "kubernetes_namespace" "rapid7" {
  provider = kubernetes
  metadata {
    annotations = {
      name = "rapid7"
    }

    labels = {
      application = "rapid7"
      name        = "rapid7"
    }

    name = "rapid7"
  }
}


resource "helm_release" "manifests" {
  provider         = helm
  name             = "rapid7"
  chart            = "${path.module}/manifests"
  version          = "1.0.0"
  namespace        = kubernetes_namespace.rapid7.id
  create_namespace = false
  force_update     = true
  lint             = true

  dynamic "set" {
    for_each = var.rapid7_overrides
    content {
      name  = set.key
      value = set.value
    }
  }


  depends_on = [
    kubernetes_secret.r7_key
  ]
}

data "google_secret_manager_secret_version" "rapid7" {
  secret  = "rapid7-api-key"
  project = "infra-sec-28bd"
}

resource "kubernetes_secret" "r7_key" {
  provider = kubernetes
  metadata {
    name      = "rapid7-monitor"
    namespace = kubernetes_namespace.rapid7.id
  }
  data = {
    "monitor-key" = data.google_secret_manager_secret_version.rapid7.secret_data
  }
}
