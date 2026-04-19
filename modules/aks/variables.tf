variable "location" {
  type = string
  default = "southindia"
}
 variable "resource_group_name" {}

variable "service_principal_name" {
  type = string
}

variable "ssh_public_key" {
  default = "C:/Users/abdul/.ssh/aks-key.pub"
}

variable "client_id" {}
variable "client_secret" {
  type = string
  sensitive = true
}

variable "node_pool_name" {
  
}
variable "cluster_name" {
  
}

variable "kubernetes_version" {
  type=string
}

variable "admin_username" {
  description = "Admin username for AKS node VMs"
  type        = string
  default     = "ubuntu"
}