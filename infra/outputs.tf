output "kubeconfig" {
  description = "Kubeconfig file content for the cluster"
  value       = module.spire.cluster_kubeconfig
}

output "spire_server_endpoint" {
  description = "SPIRE server endpoint"
  value       = module.spire.server_endpoint
}
