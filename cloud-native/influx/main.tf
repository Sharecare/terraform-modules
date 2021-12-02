resource "helm_release" "telegraf" {
  name             = "telegraf"
  repository       = "https://helm.influxdata.com/"
  chart            = "telegraf"
  version          = "1.8.6"
  namespace        = "influxdb"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  wait_for_jobs    = true
  timeout          = 300

  values = [templatefile("./${path.module}/templates/telegraf.yml", {})]
}

resource "helm_release" "influxdb" {
  name             = "influxdb"
  repository       = "https://helm.influxdata.com/"
  chart            = "influxdb2"
  version          = "2.0.1"
  namespace        = "influxdb"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  wait_for_jobs    = true
  timeout          = 300

  values     = [templatefile("./${path.module}/templates/influxdb.yml", {})]
  depends_on = [kubernetes_storage_class.influxdb]
}


resource "kubernetes_storage_class" "influxdb" {
  metadata {
    name = "influxdb-regional"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  reclaim_policy      = "Delete"
  volume_binding_mode = "Immediate"
  parameters = {
    type             = "pd-ssd"
    fsType           = "ext4" # default prefered by elasticsearch
    replication-type = "regional-pd"
  }
  allowed_topologies {
    match_label_expressions {
      key = "failure-domain.beta.kubernetes.io/zone"
      values = [
        "us-central1-b",
        "us-central1-c"
      ]
    }
  }
  allow_volume_expansion = true
}