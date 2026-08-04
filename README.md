# Azure AI Landing Zone (Terraform & Azure DevOps)

An enterprise-grade, cost-optimized **Azure Landing Zone** built with **Terraform** and **Azure DevOps Pipelines**, specifically tailored to support **Azure AI & ML Workloads** (Azure OpenAI, AI Foundry, AI Search, Cognitive Services).

For a compact, current handoff document, start with [`docs/PROJECT_CONTEXT.md`](docs/PROJECT_CONTEXT.md). It merges the repo goal, current workload goal, subscription map, deployment order, and latest troubleshooting notes.

---

## 🎯 Project Objectives

1. **Hands-On Azure DevOps & IaC Practice**: Build an Enterprise Azure Landing Zone from scratch using modular Terraform code and automated Azure DevOps CI/CD pipelines.
2. **AI Platform Infrastructure**: Prepare an enterprise-grade foundation for AI/LLM workloads, including AI API Gateways, Vector Search, and Secure Managed Identities.
3. **Cost-Optimized Architecture**: Designed for sandbox and mini-projects using **Pay-As-You-Go**, **Serverless**, and **Free-Tier** SKUs to keep running costs near zero when idle.

---

## 🔑 Subscriptions & Service Connection Mapping

This repository is configured across 4 dedicated Azure Subscriptions using **Workload Identity Federation (OIDC)** via Azure DevOps:

| Scope / Tier | Azure Subscription Name | Subscription ID | Azure DevOps Service Connection | Workload Target |
| :--- | :--- | :--- | :--- | :--- |
| **Bootstrap** | `bootstrap` | `7689ad81-71ba-481b-a17c-e1b6be61bab1` | `bootstrap` | Remote Terraform backend storage (`sthtbootpcin01`) |
| **Hub Network** | `Hub-prod` | `3eb8cc01-50c6-473e-8d5f-f8d532ae1f5b` | `hub-prod` | Hub VNet (`vnet-ht-hub-p-cin-01`) & central routing |
| **Shared Services** | `Shared-services` | `859a785c-bd38-402d-b595-1f44f40fb9bf` | `shared-services` | Log Analytics, APIM Gateway, Private DNS Zones |
| **Apps (AI Workloads)**| `Apps-prod` | `f4ffefe1-d689-4059-969c-ccc73e2a11d4` | `app-prod` | AI Assistant (`workloads/ai-assistant`), OpenAI, AI Search |

---

## 🏗️ Architecture & Folder Structure

This repository follows the **Microsoft Cloud Adoption Framework (CAF) Enterprise Pattern** using isolated, multi-root Terraform state files:

```
terraform-azure-iac/
├── AGENTS.md             # AI Agent rules, context & subscription matrix
├── ROADMAP.md            # Project progress, sprint status & phase breakdown
├── README.md             # Primary repository documentation
├── docs/                 # Architecture documentation
│   └── architecture.md   # Layered landing zone design & network details
├── platform/             # Core shared platform infrastructure (Central IT / DevOps)
│   ├── bootstrap/        # Step 1: Remote Terraform state storage & Key Vault
│   ├── hub/              # Step 2: Central Hub VNet & connectivity
│   └── shared-services/  # Step 3: Platform services (APIM AI Gateway, LAW, DNS)
├── workloads/            # Application & AI workload spokes
│   └── ai-assistant/     # AI assistant workload spoke (configured with prod.tfvars)
├── modules/              # Reusable Terraform wrapper modules
│   ├── function_app/     # Linux Function App AVM wrapper
│   ├── cognitive_account/# Azure Cognitive / OpenAI wrapper
│   ├── naming/           # Standardized Azure resource naming helper
│   ├── network/          # Virtual Network & Subnet management
│   ├── key_vault/        # Azure Key Vault with RBAC authorization
│   ├── log_analytics/    # Log Analytics Workspace for telemetry & traces
│   ├── api_management/   # APIM for AI prompt caching & rate-limiting
│   ├── private_dns_zone/ # Azure Private DNS Zones
│   └── service_plan/     # Linux App Service Plans
└── pipelines/            # Automated Azure DevOps CI/CD Workflows
    ├── azure-cicd-bootstrap.yml
    ├── azure-cicd-hub.yml
    ├── azure-cicd-shared-ser.yml
    ├── azure-cicd-ai-assistant.yml
    └── templates/        # Reusable pipeline stages (validate, plan, apply)
```

**Terraform roots vs `modules/`:** Directories under `platform/` and `workloads/` are separate Terraform roots—each has its own remote state and maps to a home Azure subscription (see table above). The `modules/` folder holds reusable wrappers only; they are not tied to a subscription until a root invokes them.

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

1. **Bootstrap Layer** ([platform/bootstrap](file:///c:/Users/RichT/OneDrive/Documents/Repos/terraform-azure-iac/platform/bootstrap)): Deploy remote state storage and backend key vault.
2. **Hub Network Layer** ([platform/hub](file:///c:/Users/RichT/OneDrive/Documents/Repos/terraform-azure-iac/platform/hub)): Provision central VNet, subnets, and routing.
3. **Shared Services Layer** ([platform/shared-services](file:///c:/Users/RichT/OneDrive/Documents/Repos/terraform-azure-iac/platform/shared-services)): Provision APIM, Log Analytics, and core services.
4. **AI Workloads Layer** ([workloads/ai-assistant](file:///c:/Users/RichT/OneDrive/Documents/Repos/terraform-azure-iac/workloads/ai-assistant)): Provision spoke VNets, Azure OpenAI endpoints, and AI Search using `prod.tfvars`.

---

## ⚙️ Region & Naming Conventions

* **Default Azure Region**: Azure Central India (`centralindia`)
* **Location Shortcode**: `cin`
* **Resource Naming Pattern**: `[resource_type]-[project]-[workload]-[environment]-[location_short]-[instance]` *(e.g., `rg-demo-hub-prod-cin-001`)*

---

## 🚀 CI/CD Pipeline Execution

Azure DevOps pipelines are located under `pipelines/`. Each layer executes through a 3-stage validation pipeline using `prod.tfvars`:
1. **Validate**: Syntax and format validation (`terraform fmt`, `terraform validate`).
2. **Plan**: Speculative state analysis using `-var-file=prod.tfvars` (`terraform plan`).
3. **Apply**: Automated deployment after approval (`terraform apply`).
