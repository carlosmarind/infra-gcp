#### If you want to create a DNS zone####
resource "google_dns_managed_zone" "devops_cl" {
  name          = "devops-cl"
  dns_name      = "devops.cl."
  description   = "devops.cl Public DNS zone"
  force_destroy = "true"
}
## to register web-server's ip address in DNS
resource "google_dns_record_set" "devops_cl" {
  count        = length(var.instance_tag)
  name         = "${google_compute_instance.default[count.index].name}.${google_dns_managed_zone.devops_cl.dns_name}"
  managed_zone = google_dns_managed_zone.devops_cl.name
  type         = "A"
  ttl          = 300
  rrdatas = [
    google_compute_instance.default[count.index].network_interface.0.access_config.0.nat_ip
  ]
}