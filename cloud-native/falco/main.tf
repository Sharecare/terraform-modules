###################### FALCO
resource "helm_release" "falco" {

  depends_on       = []
  name             = "falco"
  repository       = "https://falcosecurity.github.io/charts"
  chart            = "falco"
  version          = "1.18.5"
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
}

data "template_file" "falco_template" {
  template = file("${path.module}/templates/falco.values.yaml")
}

data "template_file" "falco_custom" {
  template = file("${path.module}/templates/custom.local.yaml")
}

###################### FALCO-SIDEKICK
resource "helm_release" "falco_sidekick" {

  depends_on       = []
  name             = "falcosidekick"
  repository       = "https://falcosecurity.github.io/charts"
  chart            = "falcosidekick"
  version          = "0.5.1"
  namespace        = "falco"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  cleanup_on_fail  = true

  set {
    name  = "config.debug"
    value = "true"
  }

  set {
    name  = "config.openfaas.functionname"
    value = "falco-pod-delete"
  }
  set {
    name  = "config.slack.webhookurl"
    value = var.webhookurl
  }
}

###################### OpenFaas DELETE-POD
data "template_file" "openfaas" {
  template = file("${path.module}/templates/openfaas.values.yaml")
}

resource "helm_release" "openfaas" {
  name             = "openfaas"
  repository       = "https://openfaas.github.io/faas-netes/"
  chart            = "openfaas"
  namespace        = "openfaas"
  version          = "10.1.1"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  cleanup_on_fail  = true

  values = [data.template_file.openfaas.rendered]
  depends_on = [
    kubernetes_namespace.openfaas-fn
  ]
}

resource "kubernetes_namespace" "openfaas-fn" {
  metadata {
    annotations = {
      name = "openfaas-fn"
    }

    labels = {
      application = "openfaas"
    }
    name = "openfaas-fn"
  }
}

resource "helm_release" "openfaas_functions" {
  name             = "openfaas-functions"
  chart            = "${path.module}/helm/openfaas"
  namespace        = kubernetes_namespace.openfaas-fn.id
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  force_update     = true
  cleanup_on_fail  = true

  depends_on = [
    helm_release.openfaas
  ]
  set {
    name  = "force_update"
    value = timestamp()
  }
}
