resource "azurerm_static_web_app" "main" {  
    name                = var.name  
    resource_group_name = var.resource_group_name  
    location            = var.location  
    sku_tier            = var.sku_tier # [40]  
    sku_size            = var.sku_size # [40]  
    tags                = var.tags     # [25, 67]  # For simplicity, repository_url/branch/token are omitted for free tier deployment  # In a real scenario, these would be configured for CI/CD integration.  # [25]: "After provisioning the Static Site, you will need to manually associate your target repository"
}

output "name" {  
    value       = azurerm_static_web_app.main.name  
    description = "The name of the Static Web App."
}

output "default_host_name" {  
    value       = azurerm_static_web_app.main.default_host_name  
    description = "The default host name of the Static Web App."
}

output "id" {  
    value       = azurerm_static_web_app.main.id  
    description = "The ID of the Static Web App."
}