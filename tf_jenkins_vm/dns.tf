resource "google_compute_address" "ip-global-jenkins" {
  name         = "ip-global-jenkins"
  address_type = "EXTERNAL"
}

resource "null_resource" "wait_for_ip" {
  depends_on = [google_compute_address.ip-global-jenkins]
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "google_compute_firewall" "jenkins-server" {
  name    = "default-allow-http-jenkins-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }
  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins"]
 
}

resource "google_dns_record_set" "kubernetes_devops_cl" {
  name         = "jenkins.${data.google_dns_managed_zone.devops_cl.dns_name}"
  managed_zone = data.google_dns_managed_zone.devops_cl.name
  type         = "A"
  ttl          = 300
  rrdatas = [
    google_compute_address.ip-global-jenkins.address
  ]
  depends_on = [
    null_resource.wait_for_ip,
    google_compute_address.ip-global-jenkins
  ]
}

