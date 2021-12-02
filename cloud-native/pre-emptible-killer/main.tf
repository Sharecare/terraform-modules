resource "helm_release" "release" {
  name          = "estafette-gke-preemptible-killer"
  repository    = "https://helm.estafette.io"
  chart         = "estafette-gke-preemptible-killer"
  version       = "1.3.0"
  lint          = true
  recreate_pods = true


  values = [
    file("./${path.module}/templates/values.yaml")
  ]
}
# 35.222.208.183