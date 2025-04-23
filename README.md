# az-functionapp-terraform
Deploy Azure Python Function App using Terraform with ZIP deployment and Blob Storage integration. Includes automated packaging, anonymous access configuration, and support for GET/POST HTTP triggers.
---
```markdown
# ⚡ Azure Function App Deployment with Terraform (Python HTTP Trigger)

This project demonstrates how to deploy a **Python-based Azure Function App** using **Terraform** with ZIP package deployment and anonymous HTTP trigger access.

---

## 📂 Project Overview

The setup includes:
- ✅ Resource Group
- ✅ Storage Account with anonymous blob access for code deployment
- ✅ App Service Plan (Linux)
- ✅ Azure Linux Function App with HTTP Trigger
- ✅ Automatic packaging of Python function code into a ZIP file

---

## 🖥️ Prerequisites

- Azure Subscription
- Azure CLI (`az login`)
- Terraform CLI (version 1.1+)
- Python 3.10 installed locally

---

## 🚀 How to Deploy

### 1️⃣ Clone the Repository
```bash
git clone git@github.com:danish-am/az-functionapp-terraform.git
cd az-functionapp-terraform/terraform
```

---

## 🔧 Remote Backend Setup (Azure Storage)

This project uses **Azure Storage Account as a remote backend** for managing the Terraform state file securely.

### Backend Configuration (`backend.tf`)
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-backend-rg1"
    storage_account_name = "tfstatebackendsa1729"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

### 📌 Azure CLI Commands to Create Backend Resources

1️⃣ **Create Resource Group:**
```bash
az group create \
  --name tfstate-backend-rg1 \
  --location eastus
```

2️⃣ **Create Storage Account:**
```bash
az storage account create \
  --name tfstatebackendsa1729 \
  --resource-group tfstate-backend-rg1 \
  --location eastus \
  --sku Standard_LRS \
  --encryption-services blob
```

3️⃣ **Create Storage Container:**
```bash
az storage container create \
  --name tfstate \
  --account-name tfstatebackendsa1729 \
  --auth-mode key
```

4️⃣ **Get Storage Account Access Key (if needed):**
```bash
az storage account keys list \
  --resource-group tfstate-backend-rg1 \
  --account-name tfstatebackendsa1729 \
  --query "[0].value" \
  --output tsv
```

✅ **Note:**  
Make sure your `backend.tf` matches this configuration, and run:
```bash
terraform init
```
to initialize and connect your project to the remote backend.

### 2️⃣ Configure Variables
Update `terraform.tfvars`:
```hcl
resource_group_name       = "azure-functions-rg"
location                  = "westeurope"
storage_account_name      = "funcapptfstorage"
app_service_plan_name     = "function-app-service-plan"
function_app_name         = "python-function-tf"
```

### 3️⃣ Initialize Terraform
```bash
terraform init
```

### 4️⃣ Validate and Plan
```bash
terraform validate
terraform plan
```

### 5️⃣ Apply to Deploy
```bash
terraform apply -auto-approve
```

---

## 📬 Access the Function App

After deployment, the output will provide your Function App URL:
```
https://<function_app_name>.azurewebsites.net/api/HttpTrigger
```

Test with:
```bash
curl "https://python-function-tf.azurewebsites.net/api/HttpTrigger?name=Danish"
```

Expected Response:
```
Hello, Danish. This function executed successfully.
```

---

## 🧹 Cleanup / Destroy Resources
```bash
terraform destroy -auto-approve
```

---

## 📝 Notes

- The Function App uses **anonymous authentication** (`authLevel = "anonymous"`) for easy access.
- The storage container is configured with **blob anonymous read access** to enable `WEBSITE_RUN_FROM_PACKAGE`.
- State files (`.tfstate`, `.terraform/`, etc.) are excluded via `.gitignore`.

---

## 👤 Author

**Danish Ahmed**  
GitHub: [danish-am](https://github.com/danish-am)

---

## 📄 License

MIT License
```
