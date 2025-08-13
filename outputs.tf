output "vm_public_ip" {
  description = "Public IP to reach Nginx"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "ssh_command" {
  description = "Convenience SSH command"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.public_ip.ip_address}"
}
