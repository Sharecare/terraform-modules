# https://github.com/knative/serving/releases/download/knative-v1.15.2/serving-crds.yaml
data "kubectl_file_documents" "serving-crds" {
    content = file("${path.module}/templates/serving/serving-crds.yaml")
}

# https://github.com/knative/serving/releases/download/knative-v1.15.2/serving-core.yaml
data "kubectl_file_documents" "serving-core" {
    content = file("${path.module}/templates/serving/serving-core.yaml")
}

# https://github.com/knative/net-kourier/releases/download/knative-v1.15.1/kourier.yaml
data "kubectl_file_documents" "kourier" {
    content = file("${path.module}/templates/serving/kourier.yaml")
}

resource "kubectl_manifest" "serving-crds" {
    for_each  = data.kubectl_file_documents.serving-crds.manifests
    yaml_body = each.value
}

resource "kubectl_manifest" "serving-core" {
    for_each  = data.kubectl_file_documents.serving-core.manifests
    yaml_body = each.value

    depends_on = [
      kubectl_manifest.serving-crds
    ]
}

resource "kubectl_manifest" "kourier" {
    for_each  = data.kubectl_file_documents.kourier.manifests
    yaml_body = each.value

    depends_on = [
      kubectl_manifest.serving-crds,
      kubectl_manifest.serving-core
    ]
}

resource "null_resource" "kourier-configmap-patch" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      kubectl patch configmap/config-network \
        --namespace knative-serving \
        --type merge \
        --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'
    EOT
  }

  depends_on = [
    kubectl_manifest.serving-crds,
    kubectl_manifest.serving-core,
    kubectl_manifest.kourier
  ]
}

resource "null_resource" "kourier-pdb-patch" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      kubectl patch pdb 3scale-kourier-gateway-pdb \
        --namespace kourier-system \
        --patch '{"spec": {"minAvailable" : ${var.kourier_pdb_min_available} }}'
    EOT
  }

  depends_on = [
    kubectl_manifest.kourier
  ]
}

resource "null_resource" "activator-pdb-patch" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      kubectl patch pdb activator-pdb \
        --namespace knative-serving \
        --patch '{"spec": {"minAvailable" : ${var.activator_pdb_min_available} }}'
    EOT
  }

  depends_on = [
    kubectl_manifest.serving-core
  ]
}

resource "null_resource" "webhook-pdb-patch" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      kubectl patch pdb webhook-pdb \
        --namespace knative-serving \
        --patch '{"spec": {"minAvailable" : ${var.webhook_pdb_min_available} }}'
    EOT
  }

  depends_on = [
    kubectl_manifest.serving-core
  ]
}