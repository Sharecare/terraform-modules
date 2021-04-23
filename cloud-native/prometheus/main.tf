###################### PROMETHEUS
resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "15.1.2"
  namespace        = "prometheus"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true

  values = [
    templatefile("./${path.module}/templates/prometheus.values.yaml", {})
  ]
}
