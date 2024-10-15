resource "azurerm_virtual_machine_extension" "installations" {
  name                 = "JumphostClientTools"
  virtual_machine_id   = azurerm_linux_virtual_machine.jumphost.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${filebase64("${path.module}/custom_scripts/installations.sh")}"
    }
SETTINGS
}