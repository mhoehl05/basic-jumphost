# --- CREDENTIALS ---
variable "subscription_id" {
  type    = string
  default = ""
}

variable "client_id" {
  type    = string
  default = ""
}

variable "client_secret" {
  type    = string
  default = ""
}

variable "tenant_id" {
  type    = string
  default = ""
}

# --- MODULE VARS ---

variable "snet_name" {
  type        = string
  default     = ""
}

variable "vnet_name" {
  type        = string
  default     = ""
}

variable "vnet_rg" {
  type        = string
  default     = ""
}

variable "public_key_path" {
  type        = string
  default     = ""
}


