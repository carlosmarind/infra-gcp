variable "ssh_password" {
  description = "password para ingresar como usuario"
  type        = string
  sensitive   = true
}

variable "instance_tag" {
  type = list(any)
  default = [
    "paldana",
    "mcorona",
    "jdiaz",
    "rguzman",
    "gjana",
    "jolmos",
    "cmd"
  ]
}

variable "services" {
  type = list(string)
  default = [
    "compute.googleapis.com",
    "artifactregistry.googleapis.com",
    "dns.googleapis.com"
  ]
}

variable "project" {
  type    = string
  default = "expertis-classroom"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "vm-type" {
  type    = string
  default = "n1-standard-1"
}
