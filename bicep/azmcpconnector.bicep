@description('Name of the Resource Group')
param resourceGroupName string
@description('Name of the Web App')
param webAppName string
@description('Name of the App Service Plan')
param appServicePlanName string = 'asp-azmpconnector'
@description('Location for all resources')
param location string = resourceGroup().location
@description('Docker image (e.g., docker.io/yourusername/azmpconnector:latest)')
param containerImage string = 'docker.io/yourusername/azmpconnector:latest'
@description('Azure Tenant ID for Service Principal')
param azureTenantId string
@description('Azure Client ID for Service Principal')
param azureClientId string
@description('Azure Client Secret for Service Principal')
@secure()
param azureClientSecret string
@description('Azure Subscription ID for Service Principal')
param azureSubscriptionId string
@description('CORS Origin')
param corsOrigin string = '*'
@description('Log Level')
param logLevel string = 'info'
@description('Node Environment')
param nodeEnv string = 'production'
@description('Web App Port')
param websitesPort string = '80'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerImage}'
      appSettings: [
        { name: 'AZURE_TENANT_ID', value: azureTenantId }
        { name: 'AZURE_CLIENT_ID', value: azureClientId }
        { name: 'AZURE_CLIENT_SECRET', value: azureClientSecret }
        { name: 'AZURE_SUBSCRIPTION_ID', value: azureSubscriptionId }
        { name: 'WEBSITES_PORT', value: websitesPort }
        { name: 'CORS_ORIGIN', value: corsOrigin }
        { name: 'LOG_LEVEL', value: logLevel }
        { name: 'NODE_ENV', value: nodeEnv }
      ]
      healthCheckPath: '/health'
    }
  }
} 