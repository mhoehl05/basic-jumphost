resource "azurerm_linux_virtual_machine" "jumphost" {
  name                = "vm-jumphost-demo-weu"
  location            = data.azurerm_resource_group.jumphost_rg.location
  resource_group_name = data.azurerm_resource_group.jumphost_rg.name
  size                = "Standard_B2s"
  admin_username      = var.admin_name

  network_interface_ids = [
    azurerm_network_interface.jumphost_nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_name
    public_key = file("${var.public_key_path_1}")
  }

  admin_ssh_key {
    username   = var.admin_name
    public_key = file("${var.public_key_path_2}")
  }

  admin_ssh_key {
    username   = var.admin_name
    public_key = file("${var.public_key_path_3}")
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