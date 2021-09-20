resource "helm_release" "release" {
  name          = "estafette-gke-preemptible-killer"
  repository    = "https://helm.estafette.io"
  chart         = "estafette-gke-preemptible-killer"
  version       = "1.3.0"
  lint          = true
  recreate_pods = true


  values = [
    "${file("./${path.module}/templates/values.yaml")}"
  ]

  set {
    name  = "cluster.enabled"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  # set_string {
  #   name  = "service.annotations.prometheus\\.io/port"
  #   value = "9127"
  # }
  depends_on = [null_resource.module_depends_on]
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}
