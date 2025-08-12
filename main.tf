locals {
  name_prefix = var.project_name
  tags = {
    project = var.project_name
    owner   = "lalityenni"
    env     = "dev"
  }
}

resource "random_integer" "suffix" {
  min = 1000
  max = 9999
  
}

resource "azurerm_resource_group" "main" {
  name     = "${local.name_prefix}-${random_integer.suffix.result}"
  location = var.location
  tags     = local.tags
}