resource "azurerm_consumption_budget_resource_group" "main" {  
    name              = var.name  
    resource_group_id = var.resource_group_id  
    amount            = var.amount # [17]  
    time_grain        = var.time_grain # [17]  
    time_period {    
        start_date = var.start_date    
        end_date   = var.end_date  
    }  

    dynamic "notification" {    
    for_each = var.notifications    
    content {      
        threshold       = notification.value.threshold      
        operator        = notification.value.operator      
        threshold_type  = notification.value.threshold_type # [17]      
        contact_emails  = notification.value.contact_emails      
        contact_groups  = notification.value.contact_groups      
        contact_roles   = notification.value.contact_roles      
        enabled         = notification.value.enabled    
        }  
    }  
    
    filter {    
        dynamic "tag" {      
            for_each = var.filter_tags      
            content {        
                name  = tag.key        
                values = tag.value      
            }    
        }  
    }
}