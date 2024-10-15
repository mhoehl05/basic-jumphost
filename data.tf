data "azurerm_resource_group" "jumphost_rg" {
  name = var.rg_name
}

data "azurerm_subnet" "jumphost_snet" {
  name                 = var.snet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}