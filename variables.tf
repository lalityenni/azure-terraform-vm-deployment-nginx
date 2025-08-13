variable "project_name" {
  description = "Short, unique name prefix applies to all azure resources"
  type        = string
  default     = "nginx"

}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "admin_username" {
  description = "Admins username used for logging in to the VM"
  type        = string
  default     = "azureadmin"

}

variable "admin_ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string

}

variable "allowed_ssh_cidr" {
  description = "CIDR block for allowed SSH access"
  type        = string
  default     = "0.0.0.0/0"

}
