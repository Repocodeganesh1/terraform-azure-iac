# Terraform landing zone repository

This folder contains the enterprise Azure Landing Zone deployment assets.

## Folder responsibilities

- [bootstrap](bootstrap) - creates the Terraform backend resource group, storage account, and blob container
- [hub](hub) - creates shared networking and connectivity infrastructure
- [shared-services](shared-services) - creates management-plane services such as monitoring and security
- [dev](dev) - contains development landing zone modules and workloads
- [prod](prod) - contains production landing zone modules and workloads
- [modules](modules) - reusable common modules for naming, tags, and shared patterns
- [pipelines](pipelines) - Azure DevOps pipeline YAML examples
- [docs](docs) - architecture and operations documentation

## Default region

All examples default to Azure Central India (`centralindia`) and use the abbreviation `cin` in naming.
