variable "name" {  
    description = "The name of the Static Web App."  
    type        = string
}

variable "resource_group_name" {  
    description = "The name of the resource group where the Static Web App will be created."  
    type        = string
}

variable "location" {  
    description = "The Azure region for the Static Web App."  
    type        = string
}

variable "sku_tier" {  
    description = "The SKU tier of the Static Web App (Free or Standard)."  
    type        = string  default     = "Free" # [40]
}

variable "sku_size" {  
    description = "The SKU size of the Static Web App (Free or Standard)."  
    type        = string  default     = "Free" # [40]
}

variable "tags" {  
    description = "A map of tags to apply to the Static Web App."  
    type        = map(string)  default     = {}
}