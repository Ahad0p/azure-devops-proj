data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

locals {
  valid_versions = data.azurerm_kubernetes_service_versions.current.versions
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_group_name}-cluster"
  node_resource_group = "${var.resource_group_name}-nrg"

  kubernetes_version = var.kubernetes_version != "" ? var.kubernetes_version : data.azurerm_kubernetes_service_versions.current.latest_version

  sku_tier = "Free"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                 = var.node_pool_name
    vm_size              = "Standard_DS2_v2"
    zones                = ["1", "2", "3"]
    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 3
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
  }

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = trimspace(file(var.ssh_public_key))
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  lifecycle {
    precondition {
      condition     = var.kubernetes_version == "" || contains(local.valid_versions, var.kubernetes_version)
      error_message = "Invalid Kubernetes version specified."
    }
  }
}