###################### PROMETHEUS
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  # version          = "14.9.0"
  namespace        = "prometheus"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true

  values = [
    templatefile("./${path.module}/templates/prometheus.values.yaml", {})
  ]
}

###################### GRAFANA

# resource "helm_release" "grafana" {
#   name       = "grafana"
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "grafana"
#   # version          = "14.9.0"
#   namespace        = "prometheus"
#   create_namespace = true
#   wait             = true
#   recreate_pods    = true
#   lint             = true

#   values = [
#     templatefile("./${path.module}/templates/prometheus.values.yaml", {})
#   ]
# }