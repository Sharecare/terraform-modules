terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "2.18.0"
    }
  }
}

variable "installCRDs" {
  type    = string
  default = "true"
}

variable "project_id" {
  type = string
}

variable "dns_project_id" {
  type = string
}

variable "provder" {
  type    = string
  default = "clouddns"
}

variable "common_name" {
  type    = string
  default = "staging.docai.beer"
}

variable "zone_name" {
  type    = string
  default = "beer"
}

variable "dns_name" {
  type    = string
  default = "staging.docai.beer."
}

variable "product" {
  type    = string
  default = "data-toniq"
}

variable "cloudflare_key" {
  type    = string
  sensitive = true
}


variable "requirements" {
  type = list(string)
}
