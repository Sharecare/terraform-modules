resource "helm_release" "jaeger" {
  name             = "jaeger"
  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaeger"
  version          = "0.47.0"
  namespace        = "jaeger"
  create_namespace = true
  wait             = true
  recreate_pods    = false
  lint             = true
  wait_for_jobs    = true
  timeout          = 300

  values = [templatefile("./${path.module}/templates/values.yaml", {})]
}
