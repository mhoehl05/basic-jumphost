resource "azurerm_public_ip" "jumphost_pip" {
  name                = "pip-jumphost-demo-weu"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "jumphost_nic" {
  name                = "nic-jumphost-demo-weu"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jumphosts.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumphost.id
  }
}

resource "azurerm_network_security_group" "jumphost_nsg" {
  name                = "nsg-jumphost-demo-weu"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

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
  network_interface_id      = azurerm_network_interface.jumphost.id
  network_security_group_id = azurerm_network_security_group.jumphost.id
}

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

resource "azurerm_virtual_machine_extension" "installations" {
  name                 = "JumphostClientTools"
  virtual_machine_id   = azurerm_linux_virtual_machine.jumphost.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${filebase64("custom_scripts/installations.sh")}"
    }
SETTINGS
}