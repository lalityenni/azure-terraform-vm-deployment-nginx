
## Terraform + GitHub Actions Project

This project demonstrates:

- **Infrastructure as Code (IaC)** — Azure infrastructure defined and managed using Terraform.
- **Clean Branching & CI/CD Strategy** — `dev` branch for daily work and planning against development environment, `main` branch for protected production planning via pull requests.
- **Environment Separation** — distinct `env/dev.tfvars` and `env/prod.tfvars` files for configuration isolation.
- **Best Practices**:
  - Provider version locking with `.terraform.lock.hcl`.
  - Secure secret handling via GitHub Actions secrets (no sensitive values in version control).
  - Consistent resource naming and tagging conventions.



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



## Terraform + GitHub Actions Project

This project demonstrates:

- **Infrastructure as Code (IaC)** — Azure infrastructure defined and managed using Terraform.
- **Clean Branching & CI/CD Strategy** — `dev` branch for daily work and planning against development environment, `main` branch for protected production planning via pull requests.
- **Environment Separation** — distinct `env/dev.tfvars` and `env/prod.tfvars` files for configuration isolation.
- **Best Practices**:
  - Provider version locking with `.terraform.lock.hcl`.
  - Secure secret handling via GitHub Actions secrets (no sensitive values in version control).
  - Consistent resource naming and tagging conventions.

