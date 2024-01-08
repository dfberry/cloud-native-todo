targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

// API
@description('The base URL used by the web service for sending API requests')
param webApiBaseUrl string = ''

// CLIENT WEB APP
param apiTodoExists bool = false
param webAppExists bool = false
param webContainerAppName string = ''
var apiContainerAppNameOrDefault = '${abbrs.appContainerApps}web-${resourceToken}'
var corsAcaUrl = 'https://${apiContainerAppNameOrDefault}.${appsEnv.outputs.domain}'

@description('Id of the user or app to assign application roles')
param principalId string

// Tags that should be applied to all resources.
// 
// Note that 'azd-service-name' tags should be applied separately to service host resources.
// Example usage:
//   tags: union(tags, { 'azd-service-name': <service name in azure.yaml> })
var tags = {
  'azd-env-name': environmentName
}

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module monitoring './shared/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    tags: tags
    logAnalyticsName: '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    applicationInsightsName: '${abbrs.insightsComponents}${resourceToken}'
  }
  scope: rg
}

module dashboard './shared/dashboard-web.bicep' = {
  name: 'dashboard'
  params: {
    name: '${abbrs.portalDashboards}${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    location: location
    tags: tags
  }
  scope: rg
}

module registry './shared/registry.bicep' = {
  name: 'registry'
  params: {
    location: location
    tags: tags
    name: '${abbrs.containerRegistryRegistries}${resourceToken}'
  }
  scope: rg
}

module keyVault './shared/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    tags: tags
    name: '${abbrs.keyVaultVaults}${resourceToken}'
    principalId: principalId
  }
  scope: rg
}

module appsEnv './shared/apps-env.bicep' = {
  name: 'apps-env'
  params: {
    name: '${abbrs.appManagedEnvironments}${resourceToken}'
    location: location
    tags: tags
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    logAnalyticsWorkspaceName: monitoring.outputs.logAnalyticsWorkspaceName
  }
  scope: rg
}

module apiTodo './app/api-todo.bicep' = {
  name: 'api-todo'
  params: {
    name: '${abbrs.appContainerApps}api-todo-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}api-todo-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: apiTodoExists
    corsAcaUrl: corsAcaUrl
    }
  scope: rg
}

// Web frontend
module clientTodo './app/client-todo.bicep' = {
  name: 'client-todo'
  scope: rg
  params: {
    name: !empty(webContainerAppName) ? webContainerAppName : '${abbrs.appContainerApps}client-todo-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}web-${resourceToken}'
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: webAppExists
    apiBaseUrl: !empty(webApiBaseUrl) ? webApiBaseUrl : apiTodo.outputs.uri
  }
}

// CLIENT FRONTEND
output CLIENT_TODO_NAME string = clientTodo.outputs.CLIENT_WEB_NAME
output CLIENT_TODO_ENDPOINT string = clientTodo.outputs.CLIENT_WEB_URI
output VITE_API_URL string = apiTodo.outputs.uri

// API BACKEND
output API_TODO_ENDPOINT string = apiTodo.outputs.uri

// APPS ENVIRONMENT
output APPS_DEFAULT_DOMAIN string = appsEnv.outputs.domain
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = registry.outputs.loginServer

// KEY VAULT
output AZURE_KEY_VAULT_NAME string = keyVault.outputs.name
output AZURE_KEY_VAULT_ENDPOINT string = keyVault.outputs.endpoint

// MONITORING
output AZURE_MONITORING_APPLICATION_INSIGHTS_INSTRUMENTATION_KEY string = monitoring.outputs.instrumentationKey
output AZURE_MONITORING_APPLICATION_INSIGHTS_CONNECTION_STRING string = monitoring.outputs.applicationInsightsConnectionString
