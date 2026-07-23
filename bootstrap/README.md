# Bootstrap subscription

This folder contains the Terraform backend bootstrap for the landing zone.

## Purpose

Deploy only the minimum required infrastructure for the Terraform backend:

- Resource Group
- Storage Account
- Blob Container

## Deployment order

1. Review variables in [terraform/bootstrap/variables.tf](variables.tf)
2. Run terraform init
3. Run terraform plan
4. Run terraform apply

## Important

This bootstrap example uses a local backend initially, then migrates state to Azure Storage after the initial deployment.
