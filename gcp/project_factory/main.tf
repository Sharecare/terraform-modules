/*
* Project Module: Create a project under a specific project and enable a list of services
*/

data "google_billing_account" "acct" {
  display_name = "Doc.ai - SADA"
  open         = true
}

module "project_factory" {
  source                      = "terraform-google-modules/project-factory/google"
  version                     = "12.0.0"
  random_project_id           = true
  name                        = var.project_name
  org_id                      = var.org_id
  billing_account             = data.google_billing_account.acct.id
  folder_id                   = var.folder_id
  disable_services_on_destroy = "true"
  activate_apis               = var.project_services
  auto_create_network         = var.auto_create_network
  default_service_account     = var.default_service_account
}
