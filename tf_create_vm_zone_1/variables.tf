variable "ssh_password" {
  description = "password para ingresar como usuario"
  type        = string
  sensitive   = true
}

variable "lab_tag" {
  type    = string
  default = "lab-servers"
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
    "mtorrejon",
    "asanmartin",
    "aespinoza",
    "dnunez",
    "icaroca",
    "pretamales"
  ]
}

variable "project" {
  type    = string
  default = "expertis-classroom"
}

variable "region_a" {
  type    = string
  default = "us-central1"
}

variable "region_b" {
  type    = string
  default = "us-east1"
}

variable "zone_a" {
  type    = string
  default = "us-central1-a"
}
variable "zone_b" {
  type    = string
  default = "us-east1-b"
}
variable "vm-type" {
  type    = string
  default = "e2-small"
}
