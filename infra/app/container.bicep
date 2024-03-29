param name string
param location string = resourceGroup().location
param tags object = {}

@secure()
param apiStatusPassword string
param port string
param env array = []

param identityName string
param applicationInsightsName string
param containerAppsEnvironmentName string
param containerRegistryName string
param keyVaultName string
param serviceName string = 'api'
param corsAcaUrl string
param exists bool

resource apiIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

// Give the API access to KeyVault
module apiKeyVaultAccess '../shared/security/keyvault-access.bicep' = {
  name: 'api-keyvault-access'
  params: {
    keyVaultName: keyVaultName
    principalId: apiIdentity.properties.principalId
  }
}

module app '../shared/host/container-app-upsert.bicep' = {
  name: '${serviceName}-container-app'
  dependsOn: [ apiKeyVaultAccess ]
  params: {
    name: name
    location: location
    tags: union(tags, { 'azd-service-name': serviceName })
    identityType: 'UserAssigned'
    identityName: apiIdentity.name
    exists: exists
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerRegistryName: containerRegistryName
    containerCpuCoreCount: '1.0'
    containerMemory: '2.0Gi'
    env: env
    targetPort: int(port)
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

output SERVICE_API_IDENTITY_PRINCIPAL_ID string = apiIdentity.properties.principalId
output SERVICE_API_NAME string = app.outputs.name
output SERVICE_API_URI string = app.outputs.uri
output SERVICE_API_IMAGE_NAME string = app.outputs.imageName
