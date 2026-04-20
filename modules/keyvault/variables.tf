variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "aks_principal_id" {
  type    = string
  default = ""
}