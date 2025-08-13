# Azure VM Deployment with Terraform & Nginx

Provision an Ubuntu 22.04 VM on Azure with VNet, NSG (SSH & HTTP), Public IP, NIC,
and cloud-init to install Nginx.

**Tech:** Azure, Terraform, GitHub Actions (OIDC), PowerShell (validation)

## How to run (local)
- az login
- terraform init
- terraform plan
- terraform apply
Testing plan workflow – dev & prod

Trigger CI: 2025-08-13T12:24:44

Trigger CI rerun: 2025-08-13T12:38:58
