terraform {  
    backend "azurerm" {    
        resource_group_name  = "tfstate-rg" # Centralized RG for state files    
        storage_account_name = "tfstatedevops" # Centralized Storage Account for state files    
        container_name       = "tfstate"    
        key                  = "dev.terraform.tfstate" # Unique state file per environment [22]  
    }
}