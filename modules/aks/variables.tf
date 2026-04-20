variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type = string
  default = "aksmanaged"
}

variable "node_count" {
  type    = number
  default = 1   # 💸 cost safe
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"  # 💸 cheaper
}

variable "environment" {
  type    = string
  default = "dev"
}