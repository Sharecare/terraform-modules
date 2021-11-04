resource "helm_release" "opensearch" {
  name             = "opensearch"
  repository       = "https://opensearch-project.github.io/helm-charts/"
  chart            = "opensearch"
  version          = "1.2.0"
  namespace        = "opensearch"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  wait_for_jobs    = true
  timeout          = 300

  values     = [templatefile("./${path.module}/templates/opensearch.values.yaml", {})]
  depends_on = [kubernetes_storage_class.opensearch]
}

resource "helm_release" "dashboards" {
  count            = var.dashboards_enabled ? 1 : 0
  name             = "opensearch-dashboards"
  repository       = "https://opensearch-project.github.io/helm-charts/"
  chart            = "opensearch-dashboards"
  version          = "1.0.5"
  namespace        = "opensearch"
  create_namespace = true
  wait             = true
  recreate_pods    = false
  lint             = true
  wait_for_jobs    = true
  timeout          = 300
  depends_on       = [helm_release.opensearch]
  values           = [templatefile("./${path.module}/templates/dashboards.values.yaml", {})]
}

# curl --user admin:admin -XPUT 'http://opensearch-cluster-master.opensearch:9200/idx'

resource "kubernetes_storage_class" "opensearch" {
  metadata {
    name = "opensearch-regional"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    type             = "pd-ssd"
    fsType           = "ext4" # default prefered by elasticsearch
    replication-type = "regional-pd"
  }
  allowed_topologies {
    match_label_expressions {
      key = "failure-domain.beta.kubernetes.io/zone"
      values = [
        "us-central1-a",
        "us-central1-b"
      ]
    }
  }
  allow_volume_expansion = true
}