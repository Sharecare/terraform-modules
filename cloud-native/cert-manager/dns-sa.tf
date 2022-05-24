resource "google_service_account" "service_account" {
  for_each     = local.clouddns_certs
  description  = "Used to pass acme dns01 challenge for ${each.key}"
  account_id   = substr("cert-manager-dns-${replace(each.key, ".", "-")}", 0, 29) #can only be 6-30 chars long
  display_name = "cert-manager-dns-${replace(each.key, ".", "-")}"
  project      = each.value.project
}

resource "google_project_iam_member" "iam" {
  for_each = local.clouddns_certs
  project  = each.value.project
  role     = "roles/dns.admin"
  member   = "serviceAccount:${google_service_account.service_account[each.key].email}"
}

resource "google_service_account_key" "key" {
  for_each           = local.clouddns_certs
  service_account_id = google_service_account.service_account[each.key].name
}
