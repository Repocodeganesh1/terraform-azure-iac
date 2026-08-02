# Azure DevOps CI/CD Pipelines

This directory contains the Azure DevOps YAML pipeline workflows and reusable stage templates for automated Terraform validation, planning, and deployment across your Enterprise Azure Landing Zone.

---

## 📂 Folder Structure

```
pipelines/
├── README.md                  # This documentation file
├── azure-cicd-bootstrap.yml   # Pipeline for platform/bootstrap
├── azure-cicd-hub.yml         # Pipeline for platform/hub
├── azure-cicd-shared-ser.yml  # Pipeline for platform/shared-services
└── templates/                 # Reusable pipeline stage templates
    ├── plan.yml               # Format check, validation & speculative terraform plan
    └── apply.yml              # Terraform apply with environment approvals
```

---

## ⚡ Key Pipeline Architecture & Features

### 1. Monorepo Path Filtering
Pipelines are configured with **Path Filtering** (`paths: include/exclude`) to ensure that changes in one infrastructure layer only trigger its specific pipeline:
* **Bootstrap Changes** (`platform/bootstrap/**`) ➔ Triggers `azure-cicd-bootstrap.yml`
* **Hub Changes** (`platform/hub/**`) ➔ Triggers `azure-cicd-hub.yml`
* **Shared Services Changes** (`platform/shared-services/**`) ➔ Triggers `azure-cicd-shared-ser.yml`
* **Documentation Edits** (`**/*.md`) ➔ **Excluded** from triggering builds to preserve agent minutes.

---

### 2. PR Validation vs. Merged Execution

* **Pull Requests (`feature/*` ➔ `develop` / `main`)**:
  * Runs **Plan Stage** (includes `terraform fmt -check`, `terraform validate`, and speculative `terraform plan`).
  * Exports JSON plan artifact for review.
  * **Apply Stage is automatically skipped** on Pull Requests to protect target infrastructure.

* **Branch Merges / Direct Commits (`develop` / `main`)**:
  * Runs **Plan Stage**.
  * Executes **Apply Stage** (`terraform apply -auto-approve tfplan.binary`) using the saved plan artifact.

---

### 3. Azure DevOps Environment Approvals

Deployment jobs in `apply.yml` bind to specific Azure DevOps Environments:
* `bootstrap-prod`
* `hub-prod`
* `shared-services-prod`

To enable **Manual Approval Gates**, navigate to **Azure DevOps ➔ Pipelines ➔ Environments**, select the environment, and configure **Approvals and checks**.

---

### 4. Performance & Caching Optimizations

* **Provider Caching (`Cache@2`)**: Shared cross-layer cache key (`terraform-providers | "$(Agent.OS)"`) prevents re-downloading AzureRM provider binaries.
* **Stage Consolidation**: Validation logic runs inside the `Plan` stage VM, eliminating unnecessary VM boot overhead.
