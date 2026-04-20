# 1. To provide the Managed Identity ID for the Role Assignment
output "principal_id" {
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  description = "The principal ID of the System-Assigned Managed Identity"
}

# 2. To provide the Kubeconfig so you can connect via kubectl
output "config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "The raw kubeconfig used by the local_file resource"
}