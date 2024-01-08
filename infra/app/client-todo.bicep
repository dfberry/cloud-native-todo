param name string
param location string = resourceGroup().location
param tags object = {}

param identityName string
param containerAppsEnvironmentName string
param containerRegistryName string
param serviceName string = 'web'
param exists bool
param apiBaseUrl string

resource webIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

module app '../shared/host/container-app-upsert.bicep' = {
  name: '${serviceName}-container-app'
  params: {
    name: name
    location: location
    tags: union(tags, { 'azd-service-name': 'client-todo' })
    identityType: 'UserAssigned'
    identityName: identityName
    exists: exists
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerRegistryName: containerRegistryName
    env: [
      {
        name: 'VITE_API_URL'
        value: apiBaseUrl
      }
    ]
    targetPort: 80
  }
}

output CLIENT_WEB_IDENTITY_PRINCIPAL_ID string = webIdentity.properties.principalId
output CLIENT_WEB_NAME string = app.outputs.name
output CLIENT_WEB_URI string = app.outputs.uri
output CLIENT_WEB_IMAGE_NAME string = app.outputs.imageName
