variable "services" {
  type = list(string)
  default = [
    "compute.googleapis.com",
    "artifactregistry.googleapis.com",
    "dns.googleapis.com",
    "container.googleapis.com",
  ]
}

variable "project" {
  type = string
  default = "expertis-classroom"
}
