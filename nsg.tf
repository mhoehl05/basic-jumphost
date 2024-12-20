resource "azurerm_network_security_group" "jumphost_nsg" {
  name                = "nsg-jumphost-demo-weu"
  location            = data.azurerm_resource_group.jumphost_rg.location
  resource_group_name = data.azurerm_resource_group.jumphost_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "jumphost_nsgassoc" {
  network_interface_id      = azurerm_network_interface.jumphost_nic.id
  network_security_group_id = azurerm_network_security_group.jumphost_nsg.id
}