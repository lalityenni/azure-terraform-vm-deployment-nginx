locals {
  name_prefix = var.project_name
  tags = {
    project = var.project_name
    owner   = "lalityenni"
    env     = "dev"
  }
}
# create a random suffix for resource names to ensure uniqueness
# this is useful if you plan to deploy multiple instances of the same configuration
# or to avoid name conflicts in Azure
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}
 # ===== Resource Group + Network Resources =====
resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}-${random_integer.suffix.result}"
  location = var.location
  tags     = local.tags
}

# ===== Network Resources =====
# Create a virtual network and subnet for the VM
# This is required for the VM to have a network interface and be reachable
# The network security group (NSG) will control inbound and outbound traffic
# The public IP will allow access to the VM from the internet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.name_prefix}"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

# Create a subnet within the virtual network
# The subnet will be used by the VM's network interface
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${local.name_prefix}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"] 
}
 
 # Create a network security group (NSG) to control traffic to the VM
resource "azurerm_network_security_group"  "nsg" {
  name                = "nsg-${local.name_prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  security_rule {
    name                       = "AllowSSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
}
# Associate the NSG with the subnet
resource "azurerm_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  
}
# Create a public IP address for the VM
resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip-${local.name_prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
  
}
# Create a network interface for the VM
resource "azurerm_network_interface" "nic" {
  name                = "nic-${local.name_prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
# Associate the NIC with the subnet and public IP
  ip_configuration {
    name                          = "ipconfig-${local.name_prefix}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
  tags = local.tags
}
# Associate the NIC with the NSG
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id


}
# ===== VM + NGINX =====

# Linux VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${local.name_prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"

  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  # SSH (reads your public key file path from variables/tfvars)
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.admin_ssh_public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Ubuntu 20.04 LTS
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  # cloud-init: install & start nginx
  custom_data = base64encode(<<EOT
#cloud-config
package_update: true
packages:
  - nginx
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
EOT
  )

  tags = local.tags
}
