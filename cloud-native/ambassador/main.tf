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

# add useragent mapping here using ambassador crd and kubectl apply