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
variable "vm-username" {
  type = string
}
variable "vm-password" {
  type        = string
  description = "password para ingresar como usuario"
  sensitive   = true
}
