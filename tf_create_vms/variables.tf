variable "ssh_password" {
  description = "password para ingresar como usuario"
  type        = string
  sensitive   = true
}

variable "lab_tag" {
  type = string
}
variable "instance_tag" {
  type = list(any)
}

variable "project" {
  type = string
}

variable "region_a" {
  type = string
}

variable "region_b" {
  type = string
}

variable "zone_a" {
  type = string

}
variable "zone_b" {
  type = string
}

variable "zone_c" {
  type = string
}
variable "vm-type" {
  type = string

}
