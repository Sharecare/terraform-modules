###################### PROMETHEUS
resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "15.1.2"
  namespace        = "prometheus"
  create_namespace = true
  wait             = true
  recreate_pods    = false
  lint             = true

  values = [
    templatefile("./${path.module}/templates/prometheus.values.yaml", {
      ALLOWED_DOMAINS      = var.allowed_domains,
      GOOGLE_CLIENT_ID     = var.google_client_id,
      GOOGLE_CLIENT_SECRET = var.google_client_secret,
      GRAFANA_URL          = var.grafana_url
      GRAFANA_ENABLED      = var.grafana_enabled
    })
  ]
}
