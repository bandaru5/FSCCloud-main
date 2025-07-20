variable "name" {  
    description = "The name of the Storage Account. Must be globally unique."  
    type        = string
}

variable "resource_group_name" {  
    description = "The name of the resource group where the Storage Account will be created."  
    type        = string
}

variable "location" {  
    description = "The Azure region for the Storage Account."  
    type        = string
}

variable "account_tier" {  
    description = "The performance tier for the Storage Account (e.g., Standard, Premium)."  
    type        = string  default     = "Standard" # [20]
}

variable "account_replication_type" {  
    description = "The replication strategy for the Storage Account (e.g., LRS, ZRS, GRS, GZRS)."  
    type        = string  default     = "LRS" # [20, 30]
}

variable "tags" {  
    description = "A map of tags to apply to the Storage Account."  
    type        = map(string)  default     = {}
}