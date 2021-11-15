resource "helm_release" "ambassador" {
  name       = "ambassador"
  repository = "https://getambassador.io"
  chart      = "ambassador"
  version    = "6.6.0"
  namespace  = "ingress"

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

resource "kubernetes_manifest" "mapping" {
  for_each = var.user_agents_block
  manifest = yamldecode(templatefile("./${path.module}/templates/user-agent-mapping.yaml",
    {
      USER_AGENT = each.value,
      SUFFIX     = each.key
  }))
  depends_on = [
    helm_release.ambassador
  ]
}

