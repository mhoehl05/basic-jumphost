resource "azurerm_public_ip" "jumphost_pip" {
  name                = "pip-jumphost-demo-weu"
  location            = data.azurerm_resource_group.jumphost_rg.location
  resource_group_name = data.azurerm_resource_group.jumphost_rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "jumphost_nic" {
  name                = "nic-jumphost-demo-weu"
  location            = data.azurerm_resource_group.jumphost_rg.location
  resource_group_name = data.azurerm_resource_group.jumphost_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.snet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumphost_pip.id
  }
}