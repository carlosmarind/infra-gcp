output "gke_cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}
output "gke_cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}
output "gke_cluster_master_version" {
  description = "The master Kubernetes version of the GKE cluster"
  value       = google_container_cluster.primary.master_version
}
#output "bastion_ip" {
#  description = "The public IP of the bastion host"
#  value       = google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip
#                
#}
