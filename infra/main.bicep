param location string = 'uksouth'
param functionAppName string = 'func-ai-crm2'
param storageAccountName string = 'stcrm1753223711'
param keyVaultName string = 'kv-ai-crm'

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {}
}

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: { family: 'A', name: 'standard' }
    tenantId: subscription().tenantId
    accessPolicies: []
    enableSoftDelete: true
  }
}

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'plan-ai-crm'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  identity: { type: 'SystemAssigned' }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'Python|3.11'
      appSettings: [
        { name: 'FUNCTIONS_WORKER_RUNTIME', value: 'python' }
        { name: 'WEBSITE_RUN_FROM_PACKAGE', value: '1' }
        { name: 'DEPLOYMENT_NAME', value: 'gpt-4o-mini' }
        { name: 'OPENAI_KEY', value: '@Microsoft.KeyVault(OPENAI_KEY)' }
        { name: 'HUBSPOT_TOKEN', value: '@Microsoft.KeyVault(HUBSPOT_TOKEN)' }
      ]
    }
    httpsOnly: true
  }
  dependsOn: [plan, storage]
}
