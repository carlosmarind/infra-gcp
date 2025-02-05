resource "google_compute_firewall" "lab-servers" {
  name    = "default-allow-ssh-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.lab_tag]

}