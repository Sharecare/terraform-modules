resource "helm_release" "ambassador" {
  name         = "ambassador"
  repository   = "https://getambassador.io"
  chart        = "ambassador"
  version      = "6.6.0"
  namespace    = "ingress"
  force_update = true
  lint         = true

  # override values as a heredoc use the file in ./templates/values.yaml as
  # a reference
  values = [var.values_override]

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "authService.create"
    value = "false"
  }

  set {
    name  = "RateLimit.create"
    value = "false"
  }

  set {
    name  = "env.STATSD_ENABLED"
    value = "true"
  }

  set {
    name  = "env.STATSD_HOST"
    value = "localhost"
  }
}

resource "helm_release" "manifests" {
  name         = "ambassador-manifests"
  chart        = "${path.module}/manifests"
  version      = "1.0.0"
  namespace    = "ingress"
  force_update = true
  lint         = true

#  dynamic "set" {
#    for_each = var.user_agents_block
#    content {
#      name  = "user_agent_mappings.${set.key}"
#      value = set.value
#    }
#  }
  depends_on = [
    helm_release.ambassador
  ]
}