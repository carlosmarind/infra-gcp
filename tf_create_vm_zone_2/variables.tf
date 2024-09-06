variable "ssh_password" {
  description = "password para ingresar como usuario"
  type        = string
  sensitive   = true
}

variable "instance_tag" {
  type = list(any)
  default = [
    "mtorrejon",
    "asanmartin",
    "aespinoza",
    "dnunez",
    "icaroca",
    "pretamales"
  ]
}

variable "project" {
  type = string
  default = "expertis-classroom"
}

variable "region" {
  type = string
  default = "us-east1"
}

variable "zone" {
  type = string
  default = "us-east1-b"
}

variable "vm-type" {
  type = string
  default = "n1-standard-1"
}