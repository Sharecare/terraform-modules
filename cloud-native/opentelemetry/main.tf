###################### OPENTELEMETRY
resource "helm_release" "opentelemetry" {
  name             = "opentelemetry"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-collector"
  version          = "0.5.9"
  namespace        = "opentelemetry"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true

  values = [
    templatefile("./${path.module}/templates/opentelemetry.values.yaml", {})
  ]
}
