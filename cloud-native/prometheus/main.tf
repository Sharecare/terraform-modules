###################### PROMETHEUS
resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "20.0.1"
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
      CLUSTER_NAME         = var.cluster_name
    })
  ]

  dynamic "set" {
    for_each = var.values_override
    content {
      name  = set.key
      value = set.value
    }
  }
}


resource "kubernetes_config_map" "init-opensearch-dashboards" {
  metadata {
    name      = "grafana-dashboards"
    namespace = "prometheus"
    labels = {
      prometheus = "prometheus"
    }
    annotations = {
      k8s-sidecar-target-directory = "/tmp/dashboards/toniq"
    }
  }

  data = {
    "toniq-ambassador-13758.json" = file("${path.module}/templates/toniq-ambassador-13758.json")
    "toniq-argo-13927.json"       = file("${path.module}/templates/toniq-argo-13927.json")
    "toniq-hub.json"              = file("${path.module}/templates/toniq-hub.json")
    "toniq-jupyter-notebook.json" = file("${path.module}/templates/toniq-jupyter-notebook.json")
    "toniq-mariadb-7362.json"     = file("${path.module}/templates/toniq-mariadb-7362.json")
    "toniq-minio-13502.json"      = file("${path.module}/templates/toniq-minio-13502.json")
    "toniq-nats-2279.json"        = file("${path.module}/templates/toniq-nats-2279.json")
    "toniq-presto.json"           = file("${path.module}/templates/toniq-presto.json")
    "toniq-spark.json"            = file("${path.module}/templates/toniq-spark.json")
  }
  depends_on = [helm_release.prometheus]
}
