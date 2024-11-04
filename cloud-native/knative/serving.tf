# https://github.com/knative/serving/releases/download/knative-v1.15.2/serving-crds.yaml
data "kubectl_file_documents" "serving-crds" {
    content = file("${path.module}/templates/serving/serving-crds.yaml")
}

# https://github.com/knative/serving/releases/download/knative-v1.15.2/serving-core.yaml
data "kubectl_file_documents" "serving-core" {
    # NOTE serving-core.yaml contains the following changes from the original file provided by knative:
    # a new line was inserted at line 8101:
    #    ingress-class: "kourier.ingress.networking.knative.dev"
    content = file("${path.module}/templates/serving/serving-core.yaml")
}

# https://github.com/knative/net-kourier/releases/download/knative-v1.15.1/kourier.yaml
data "kubectl_file_documents" "kourier" {
    # NOTE kourier.yaml contains the following changes from the original file provided by knative:
    # changed line 655 from:
    #    minAvailable: 80%
    # to
    #    minAvailable: KOURIER_PDB_MIN_AVAILABLE
    content = file("${path.module}/templates/serving/kourier.yaml")
}

resource "kubectl_manifest" "serving-crds" {
    for_each  = data.kubectl_file_documents.serving-crds.manifests
    yaml_body = each.value
}

resource "kubectl_manifest" "serving-core" {
    for_each  = data.kubectl_file_documents.serving-core.manifests

    # Chained 'replace' functions are not ideal
    yaml_body = replace(
      replace(each.value, "ACTIVATOR_PDB_MIN_AVAILABLE", var.activator_pdb_min_available), 
      "WEBHOOK_PDB_MIN_AVAILABLE",
      var.webhook_pdb_min_available
    )

    depends_on = [
      kubectl_manifest.serving-crds
    ]
}

resource "kubectl_manifest" "kourier" {
    for_each  = data.kubectl_file_documents.kourier.manifests
    yaml_body = replace(each.value, "KOURIER_PDB_MIN_AVAILABLE", var.kourier_pdb_min_available)

    depends_on = [
      kubectl_manifest.serving-crds,
      kubectl_manifest.serving-core
    ]
}
