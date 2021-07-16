###################### JAEGER
resource "helm_release" "jaeger" {
  name             = "jaeger"
  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaeger"
  version          = "0.46.4"
  namespace        = "jaeger"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true

  values = [
    templatefile("./${path.module}/templates/jaeger.values.yaml", {
      ELASTICSEARCH_PASSWORD = var.elasticsearch_password
      JAEGER_URL             = var.jaeger_url
    })
  ]
}
