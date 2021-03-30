
output "service_account" {
  value = module.gke.service_account
}


output "attributes" {
  value = module.gke
  sensitive = true
}