resource "helm_release" "datadog" {
  name          = "datadog"
  repository    = "https://helm.datadoghq.com"
  chart         = "datadog"
  version       = "2.35.6"
  namespace     = "default"
  lint          = true
  force_update  = true
  recreate_pods = true


  values = [
    templatefile("./${path.module}/templates/values.yaml",
      {
        DATADOG_API_KEY = var.datadog_api_key
    })
  ]
}