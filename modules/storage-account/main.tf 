resource "azurerm_storage_account" "main" {  
    name                     = var.name  
    resource_group_name      = var.resource_group_name  
    location                 = var.location  
    account_tier             = var.account_tier  
    account_replication_type = var.account_replication_type # [20, 30]  
    tags                     = var.tags                   # [68]  
    
    # Enable static website hosting for potential use with Static Web App  
    static_website {    
        index_document     = "index.html"    
        error_404_document = "404.html"  
    }
}

output "name" {  
    value       = azurerm_storage_account.main.name  
    description = "The name of the Storage Account."
}

output "primary_blob_host" {  
    value       = azurerm_storage_account.main.primary_blob_host  
    description = "The primary blob endpoint for the Storage Account."
}

output "primary_web_host" {  
    value       = azurerm_storage_account.main.primary_web_host  
    description = "The primary static website endpoint for the Storage Account."
}

output "id" { 
     value       = azurerm_storage_account.main.id  
     description = "The ID of the Storage Account."
}