terraform {  
    backend "azurerm" {    
        resource_group_name  = "tfstate-rg"    
        storage_account_name = "tfstatedevops"    
        container_name       = "tfstate"    
        key                  = "test.terraform.tfstate" # Unique state file [22]  
    }
}