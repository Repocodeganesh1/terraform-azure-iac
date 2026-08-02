# Azure AI Landing Zone (Terraform & Azure DevOps)

An enterprise-grade, cost-optimized **Azure Landing Zone** built with **Terraform** and **Azure DevOps Pipelines**, specifically tailored to support **Azure AI & ML Workloads** (Azure OpenAI, AI Foundry, AI Search, Cognitive Services).

---

## 🎯 Project Objectives

1. **Hands-On Azure DevOps & IaC Practice**: Build an Enterprise Azure Landing Zone from scratch using modular Terraform code and automated Azure DevOps CI/CD pipelines.
2. **AI Platform Infrastructure**: Prepare enterprise-grade foundation for AI/LLM workloads, including AI API Gateways, Vector Search, and Secure Managed Identities.
3. **Cost-Optimized Architecture**: Designed for sandbox and mini-projects using **Pay-As-You-Go**, **Serverless**, and **Free-Tier** SKUs to keep running costs near zero when idle.

---

## 🏗️ Architecture & Folder Structure

This repository follows a **Multi-Root Terraform State** pattern aligned with the Microsoft Cloud Adoption Framework (CAF) Hub-and-Spoke model:

```
terraform-azure-iac/
├── docs/                 # Architecture diagrams, deployment guides & documentation
│   └── architecture.md   # Layered landing zone architecture details
├── environments/         # Layered, state-isolated Terraform root modules
│   ├── bootstrap/        # Step 1: Remote Terraform state storage & Key Vault
│   ├── hub/              # Step 2: Hub networking & central connectivity
│   ├── shared-services/  # Step 3: Platform services (APIM AI Gateway, LAW, DNS)
│   ├── app1/             # Step 4: Spoke application landing zone (Dev/Prod)
│   └── app2/             # Step 4: Additional workload landing zone placeholder
├── modules/              # Reusable Terraform wrapper modules
│   ├── naming/           # Standardized Azure resource naming helper
│   ├── network/          # Virtual Network & Subnet management
│   ├── key_vault/        # Azure Key Vault with RBAC authorization
│   ├── log_analytics/    # Log Analytics Workspace for telemetry & traces
│   ├── api_management/   # APIM for AI prompt caching & rate-limiting
│   ├── private_dns_zone/ # Azure Private DNS Zones
│   ├── service_plan/     # Linux App Service Plans
│   └── common/           # Common utilities & metadata
└── pipelines/            # Automated Azure DevOps CI/CD Workflows
    ├── azure-cicd-bootstrap.yml
    ├── azure-cicd-hub.yml
    ├── azure-cicd-shared-ser.yml
    └── templates/        # Reusable pipeline stages (validate, plan, apply)
```

---

## 💰 Cost Efficiency & SKU Guide

To practice AI Platform Engineering without high monthly cloud bills, resources are configured using minimal cost options:

| Component | Architecture Role | Target Cost-Saving SKU |
| :--- | :--- | :--- |
| **API Management** | AI Gateway (Rate limiting / Caching) | `Consumption_0` ($0 idle) |
| **App Service Plan** | Web API & Bot backends | `F1` (Free) or `B1` (Basic) |
| **Log Analytics** | AI Tracing & Monitoring | `PerGB2018` with low retention (7–30 days) |
| **Storage Account** | Terraform `.tfstate` | `Standard_LRS` |
| **Key Vault** | Secrets & Managed Identities | `Standard` with RBAC enabled |
| **Azure OpenAI / AI Services** | LLM APIs & Vector Search | **Pay-As-You-Go** with strict quota caps & `Free` (F1) search tier |

---

## 🗺️ Deployment Sequence

To deploy this landing zone sequentially, follow these steps:

1. **Bootstrap Layer** ([environments/bootstrap](file:///c:/Users/RichT/OneDrive/Documents/Repos/terraform-azure-iac/environments/bootstrap)): Deploy remote state storage and backend key vault.
2. **Hub Network Layer** ([environments/hub](file:///c:/Users/RichT/OneDrive/Documents/Repos/terraform-azure-iac/environments/hub)): Provision central VNet, subnets, and routing.
3. **Shared Services Layer** ([environments/shared-services](file:///c:/Users/RichT/OneDrive/Documents/Repos/terraform-azure-iac/environments/shared-services)): Provision APIM, Log Analytics, and core services.
4. **AI Workloads / Spokes**: Provision spoke VNets, Azure OpenAI endpoints, and AI Search.

---

## ⚙️ Region & Naming Conventions

* **Default Azure Region**: Azure Central India (`centralindia`)
* **Location Shortcode**: `cin`
* **Resource Naming Pattern**: `[resource_type]-[project]-[workload]-[environment]-[location_short]-[instance]` *(e.g., `rg-demo-hub-prod-cin-001`)*

---

## 🚀 CI/CD Pipeline Execution

Azure DevOps pipelines are located under `pipelines/`. Each layer executes through a 3-stage validation pipeline:
1. **Validate**: Syntax and format validation (`terraform fmt`, `terraform validate`).
2. **Plan**: Speculative state analysis (`terraform plan`).
3. **Apply**: Automated deployment after approval (`terraform apply`).

