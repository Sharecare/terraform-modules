resource "null_resource" "k8_service_account" {
  triggers = { always_run = timestamp() }
  provisioner "local-exec" {
    command = "gcloud container clusters describe  $CLUSTER --project $PROJECT_ID --region $REGION | grep \"serviceAccount\" | cut -d\":\" -f2 | sort -u | xargs | head -1 > ${path.module}/k8_service_account.txt"

    environment = {
      CLUSTER    = var.cluster
      REGION     = var.region
      PROJECT_ID = var.project_id
    }
  }

}

data "local_file" "service_account_file" {
  filename   = "${path.module}/k8_service_account.txt"
  depends_on = [null_resource.k8_service_account]
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/iam.workloadIdentityUser"

    members = [
      "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.k8_service_account}]",
    ]
  }
}

resource "google_service_account_iam_policy" "admin-account-iam" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${trimspace(data.local_file.service_account_file.content)}"
  policy_data        = data.google_iam_policy.admin.policy_data
}

resource "google_project_iam_binding" "project" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${trimspace(data.local_file.service_account_file.content)}",
  ]
}

data "template_file" "template_values_file" {
  template = file("${path.module}/templates/values.tpl")
  vars = {
    gcp_service_account = trimspace(data.local_file.service_account_file.content)
    k8_service_account  = var.k8_service_account
  }
}

resource "helm_release" "externalsec" {

  name = "externalsec"
  #repository       = "https://external-secrets.github.io/kubernetes-external-secrets"
  chart            = "external-secrets/kubernetes-external-secrets"
  version          = "6.1.0"
  namespace        = var.namespace
  create_namespace = true
  wait             = true

  values = [
    data.template_file.template_values_file.rendered
  ]
}

resource "null_resource" "done" {
  depends_on = [
    helm_release.externalsec
  ]
}
