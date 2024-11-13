###################### FALCO
resource "helm_release" "falco" {

  depends_on       = []
  name             = "falco"
  repository       = "https://falcosecurity.github.io/charts"
  chart            = "falco"
  version          = "4.11.1"
  namespace        = "falco"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  cleanup_on_fail  = true

  values = [
    data.template_file.falco_template.rendered,
    data.template_file.falco_custom.rendered
  ]

  set {
    name  = "falcosidekick.enabled"
    value = true
  }

  # -- DEBUG environment variable
  set {
    name  = "falcosidekick.config.debug"
    value = true
  }

  # -- a list of escaped comma separated custom fields to add to falco events, syntax is "key:value\,key:value"
  set {
    name  = "falcosidekick.config.customfields"
    value = "cluster:${var.cluster_name}"
  }

  set {
    name  = "falcosidekick.config.slack.webhookurl"
    value = var.webhookurl
  }

  set {
    name  = "falcosidekick.config.cloudevents.address"
    value = "http://broker-ingress.knative-eventing.svc.cluster.local/default/default"
  }
}

data "template_file" "falco_template" {
  template = file("${path.module}/templates/falco.values.yaml")
}

data "template_file" "falco_custom" {
  template = file("${path.module}/templates/custom.local.yaml")
}
