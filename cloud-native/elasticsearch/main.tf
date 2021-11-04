resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"
  version          = "7.15.0"
  namespace        = "elasticsearch"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  wait_for_jobs    = true
  timeout          = 300

  values     = [templatefile("./${path.module}/templates/elasticsearch.values.yaml", {})]
  depends_on = [kubernetes_storage_class.elastic]
}

resource "helm_release" "kibana" {
  count            = var.kibana_enabled ? 1 : 0
  name             = "kibana"
  repository       = "https://helm.elastic.co"
  chart            = "kibana"
  version          = "7.15.0"
  namespace        = "elasticsearch"
  create_namespace = true
  wait             = true
  recreate_pods    = false
  lint             = true
  wait_for_jobs    = true
  timeout          = 300
  depends_on       = [helm_release.elasticsearch]
  values           = [templatefile("./${path.module}/templates/kibana.values.yaml", {})]
}

resource "helm_release" "metricbeat" {
  count            = var.metricbeat_enabled ? 1 : 0
  name             = "metricbeat"
  repository       = "https://helm.elastic.co"
  chart            = "metricbeat"
  version          = "7.15.0"
  namespace        = "elasticsearch"
  create_namespace = true
  wait             = true
  recreate_pods    = false
  lint             = true
  wait_for_jobs    = true
  timeout          = 240

  values     = [templatefile("./${path.module}/templates/metricbeat.yaml", {})]
  depends_on = [helm_release.kibana, helm_release.elasticsearch]

}

resource "kubernetes_storage_class" "elastic" {
  metadata {
    name = "elasticsearch-regional"
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
