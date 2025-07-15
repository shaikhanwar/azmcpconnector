# Azure MCP Solution - Complete Deployment Guide

This repository contains a complete Azure MCP (Model Context Protocol) solution with **two main components**:

1. **Azure MCP Connector** - A containerized MCP server for Azure App Service
2. **Azure MCP Assistant** - A Copilot Agent with Power Automate Flow integration

## 📦 Solution Components

### 1. Azure MCP Connector
A simple, containerized Azure MCP server that you can deploy to Azure App Service with just a few clicks. The application is designed to run the MCP server as a child process and proxy requests to it, providing a stable, containerized environment for the service.

### 2. Azure MCP Assistant (NEW!)
A Copilot Studio agent that initializes the MCP Server, loads tools, and lets you execute queries using a conversational chatbot interface. This agent includes Power Automate Flow integration and can be deployed to Microsoft Teams.

**Solution File**: `copilot-agent/AzureMCPAssistant_1_0_0_1_managed.zip`

## 🤖 What can you do with the Azure MCP Assistant?

The Azure MCP Server supercharges your agents with Azure context. Here are some cool prompts you can try:

### Azure Resource Management
```
"List my resource groups"
```

### Azure Storage
```
"List my Azure storage accounts"
"List my Azure storage containers"
```

### Azure Monitor
```
"List my Log Analytics Workspaces"
"Query my Log Analytics workspace"
```

> **📝 Note**: Currently only Sign-In Logs and Audit Logs are configured with this solution. However, the Topic can be updated to support any required tables.

### Key Features
- **Natural Language Interface**: Interact with Azure resources through conversational prompts
- **Progressive Discovery**: Guided flows for workspace → table → query selection
- **Teams Integration**: Deploy the MCP Client "Azure MCP Assistant" to Teams for user interaction
- **Initial Setup**: The MCP Client starts by setting up the Subscription and Log Analytics Workspace for the first time
- **Intelligent Query Generation**: Dynamic KQL query generation based on user requirements

## Overview

This project provides a containerized and cloud-ready deployment of the Azure MCP server, allowing remote connections while maintaining the simplicity of the original `@azure/mcp` package. The solution acts as a proxy that forwards all queries to the official Azure MCP server without reinventing authentication or core functionality.

## What is Azure MCP Server?

The Azure MCP Server enables AI agents and other types of clients to interact with Azure resources through natural language commands. It implements the Model Context Protocol (MCP) to provide these key features:

- **MCP support**: Works with MCP clients such as GitHub Copilot agent mode, the OpenAI Agents SDK, and Semantic Kernel
- **Entra ID support**: Uses Entra ID through the Azure Identity library to follow Azure authentication best practices
- **Service and tool support**: Supports Azure services and tools such as the Azure CLI and Azure Developer CLI (azd)

The Azure MCP Server implements a set of tools per the Model Context Protocol, allowing AI agents and other clients to interact with Azure resources using natural language. For example, you could use GitHub Copilot agent mode with the Azure MCP Server to list Azure storage accounts or run KQL queries on Azure databases.

For more information, see the [Azure MCP Server documentation](https://learn.microsoft.com/en-us/azure/developer/azure-mcp-server/overview).

## 📋 Prerequisites

Before you can deploy the MCP connector, you need to set up Azure authentication. This is a **required first step**.

### Step 1: Create Azure Service Principal

The MCP server needs to authenticate with Azure. You'll need to create a Service Principal:

1. **Open Azure CLI** (install from [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) if needed)

2. **Login to Azure**:
   ```bash
   az login
   ```

3. **Create Service Principal**:
   ```bash
   az ad sp create-for-rbac --name "AzureMCPConnector" --role "Contributor"
   ```

4. **⚠️ IMPORTANT: Save the credentials!** 
   
   The command will output something like this:
   ```json
   {
     "appId": "12345678-1234-1234-1234-123456789012",
     "displayName": "AzureMCPConnector",
     "password": "your-secret-password",
     "tenant": "87654321-4321-4321-4321-210987654321"
   }
   ```
   
   **You MUST save these values - you cannot retrieve the password later!**
   
   - `appId` → **AZURE_CLIENT_ID**
   - `password` → **AZURE_CLIENT_SECRET**  
   - `tenant` → **AZURE_TENANT_ID**
   - Your **AZURE_SUBSCRIPTION_ID** (get it with `az account show --query id --output tsv`)

5. **Get your Subscription ID**:
   ```bash
   az account show --query id --output tsv
   ```

> **💡 Alternative: Using Azure Portal**
> 
> If you prefer to create the Service Principal using the Azure Portal GUI:
> 1. Go to [Azure Portal](https://portal.azure.com) → Azure Active Directory → App registrations
> 2. Click "New registration"
> 3. Name: "AzureMCPConnector"
> 4. Select "Accounts in this organizational directory only"
> 5. Click "Register"
> 6. Note the **Application (client) ID** and **Directory (tenant) ID**
> 7. Go to "Certificates & secrets" → "New client secret"
> 8. Add description and set expiration, then click "Add"
> 9. **Copy the secret value immediately** (you won't see it again)
> 10. Go to "API permissions" → "Add permission" → "Azure Service Management" → "Delegated permissions" → "user_impersonation"
> 11. Click "Grant admin consent"
> 12. Go to "Enterprise applications" → find your app → "Assign users and groups" → add yourself with "Contributor" role

## 🤖 Deploy Azure MCP Assistant (Copilot Agent)

The Azure MCP Assistant is a ready-to-use Copilot Studio solution that provides a conversational interface to your Azure resources.

### Prerequisites for Copilot Agent
- Microsoft 365 subscription with Copilot Studio access
- Power Platform environment
- Completed Azure Service Principal setup (from Step 1 above)

### Deployment Steps

1. **Import the Solution**:
   - Download the solution file: `copilot-agent/AzureMCPAssistant_1_0_0_1_managed.zip`
   - Go to [Power Platform Admin Center](https://admin.powerplatform.microsoft.com/)
   - Select your environment
   - Go to Solutions → Import solution
   - Upload the `AzureMCPAssistant_1_0_0_1_managed.zip` file

2. **Configure the Power Automate Flow**:
   - Open the imported "Azure MCP Tool Executor" flow
   - Update the MCP server endpoint to your deployed Azure App Service URL
   - Configure authentication settings with your Service Principal credentials

3. **Publish the Copilot Agent**:
   - Open Copilot Studio
   - Find the "Azure MCP Assistant" agent
   - Test the agent with sample prompts
   - Publish to Teams or other channels

4. **Initial User Setup**:
   - Users will first set up their Subscription ID
   - Then configure their preferred Log Analytics Workspace
   - After setup, users can start querying with natural language

### Teams Integration
Once deployed, the MCP Client "Azure MCP Assistant" can be made available in Microsoft Teams, allowing users to interact with Azure resources through a conversational interface.

## 🚀 Deploy Azure MCP Connector

Now that you have your Azure credentials, you can deploy the MCP connector:

### Option 1: One-Click Deployment (Recommended)

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fshaikhanwar%2Fazmcpconnector%2Fmain%2Fbicep%2Fazmcpconnector.json)

1. Click the "Deploy to Azure" button above
2. Fill in the required information:
   - **Resource Group**: Choose an existing one or create new
   - **Web App Name**: Choose a unique name for your app
   - **Docker Image**: `shaikhanwar/azmcpconnector:latest` (pre-filled)
   - **Azure Credentials**: Use the values you saved from Step 1:
     - **Tenant ID**: Your AZURE_TENANT_ID
     - **Client ID**: Your AZURE_CLIENT_ID  
     - **Client Secret**: Your AZURE_CLIENT_SECRET
     - **Subscription ID**: Your AZURE_SUBSCRIPTION_ID
3. Click "Review + Create" and then "Create"
4. Wait for deployment to complete (usually 2-3 minutes)

### Option 2: Manual Deployment

If you prefer to deploy manually or need to customize the deployment:

```bash
az deployment group create \
  --resource-group "your-resource-group" \
  --template-file bicep/azmcpconnector.bicep \
  --parameters webAppName="your-app-name" \
  dockerImage="shaikhanwar/azmcpconnector:latest"
```

## 📱 Connect Your MCP Client

Once deployed, configure your MCP client (like VS Code) to connect:

### VS Code Configuration
Add this to your VS Code settings (`Ctrl+Shift+P` → "Preferences: Open Settings (JSON)"):

```json
{
  "mcp": {
    "servers": {
      "Azure MCP": {
        "url": "https://your-app-name.azurewebsites.net/mcp"
      }
    }
  }
}
```

Replace `your-app-name` with the actual name you used during deployment.

## ✅ Verify Deployment

1. **Check the app is running**: Visit `https://your-app-name.azurewebsites.net/health`
2. **Test MCP connection**: Try connecting from your MCP client
3. **Check logs**: In Azure Portal → App Service → Log stream

> **⏰ Important Note**: After deployment, the application may take **15-30 minutes** to be fully operational. During this time, the health endpoint might not respond immediately. Once the deployment is complete, you can test the application using:
> 
> ```bash
> curl -i https://your-app-name.azurewebsites.net/health
> ```
> 
> Replace `your-app-name` with your actual App Service name. The application was tested and verified working with VS Code MCP client after the initial deployment period.

## 🔧 Post-Deployment Verification

After deployment, verify these critical settings in Azure Portal:

### Environment Variables
Go to App Service → Configuration → Application settings and ensure:

| Variable | Value | Required |
|----------|-------|----------|
| `WEBSITES_PORT` | `80` | ✅ Yes |
| `AZURE_CLIENT_ID` | Your Service Principal Client ID | ✅ Yes |
| `AZURE_CLIENT_SECRET` | Your Service Principal Client Secret | ✅ Yes |
| `AZURE_TENANT_ID` | Your Azure Tenant ID | ✅ Yes |
| `AZURE_SUBSCRIPTION_ID` | Your Azure Subscription ID | ✅ Yes |

### Port Configuration
- **Only set `WEBSITES_PORT` to `80`** (remove any custom `PORT` setting)
- This ensures Azure routes traffic correctly to your container
- Port 80 is the standard for HTTP and recommended for production

### VS Code Configuration
Add this to your VS Code settings (`Ctrl+Shift+P` → "Preferences: Open Settings (JSON)"):

```json
{
  "mcp": {
    "servers": {
      "Azure MCP": {
        "url": "https://your-app-name.azurewebsites.net/mcp"
      }
    }
  }
}
```

Replace `your-app-name` with your actual App Service name.

## 🔧 Troubleshooting

### Common Issues

**App returns 503 errors:**
- Check that all Azure credentials are correctly set
- Verify the Service Principal has Contributor permissions
- Check the log stream for detailed error messages

**Can't connect from MCP client:**
- Ensure you're using the correct URL format: `https://your-app-name.azurewebsites.net/mcp`
- Check that CORS is properly configured
- Verify the app is running (check health endpoint)

**Authentication errors:**
- Double-check your Service Principal credentials
- Ensure the Service Principal hasn't expired
- Verify the subscription ID is correct

### Getting Help

- **Logs**: Check Azure Portal → App Service → Log stream
- **Health Check**: Visit `/health`

## 🎯 Complete Solution Summary

This repository provides a comprehensive Azure MCP solution with two deployment options:

### Option 1: Azure MCP Connector Only
- Deploy the containerized MCP server to Azure App Service
- Connect using VS Code or other MCP clients
- Direct HTTP/JSON-RPC integration
- Best for: Developers and technical users

### Option 2: Complete Solution (Recommended)
- Deploy both the Azure MCP Connector AND the Azure MCP Assistant
- Get a conversational Copilot agent with natural language interface
- Teams integration for end-user access
- Best for: Organizations wanting user-friendly Azure resource management

### Deployment Order
1. **First**: Deploy Azure MCP Connector (provides the backend service)
2. **Second**: Import and configure Azure MCP Assistant (provides the user interface)
3. **Third**: Publish to Teams for organization-wide access

### Key Benefits
- ✅ **Natural Language**: "List my storage accounts" instead of complex CLI commands
- ✅ **Progressive Discovery**: Guided workflows for complex operations
- ✅ **Teams Integration**: Accessible where users already work
- ✅ **Log Analytics**: Query Sign-In and Audit logs with conversational interface
- ✅ **Extensible**: Solution can be modified to support additional tables and tools

---

**Ready to get started?** Begin with the Azure MCP Connector deployment above, then add the Copilot Assistant for a complete conversational Azure management experience! 🚀