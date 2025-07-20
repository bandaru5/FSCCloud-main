terraform {  
  required_version = ">= 1.0.0"  
  
  required_providers {    
    azurerm = {      
      source  = "hashicorp/azurerm"      
      version = "~> 3.0" 
  }
 }
}

provider "azurerm" {
  features{}  
# Authenticate with Azure CLI for simplicity in demo  # In production, it is recommended to use Service Principal or Managed Identity for authentication.
}
