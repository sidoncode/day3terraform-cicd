terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "student_name" {
  description = "Your unique short nickname, e.g. stu1"
  type        = string
}

# Random suffix so the storage account name is guaranteed unique
resource "random_id" "suffix" {
  byte_length = 3
}

# A resource group just for this student
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.student_name}"
  location = "eastus"
}

# The storage account
resource "azurerm_storage_account" "sa" {
  name                     = "sa${var.student_name}${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}
