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
variable "region" {
  type = string
}
variable "zone" {
  type = string
}
variable "vm-type" {
  type = string
}
