resource "azurerm_linux_virtual_machine" "jumphost" {
  name                = "vm-jumphost-demo-weu"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  size                = "Standard_B2s"
  admin_username      = "adm_ubuntu"

  network_interface_ids = [
    azurerm_network_interface.jumphost.id,
  ]

  admin_ssh_key {
    username   = "adm_ubuntu"
    public_key = file("${var.public_key_path}")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}