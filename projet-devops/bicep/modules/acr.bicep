param location string 
param name string
param ids object

// Création du registre de conteneurs (ACR)
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic' 
  }
  properties: {
    adminUserEnabled: true 
  }
}

// Autoriser runner gitlab à push une image docker
resource acrPushAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, ids.ObjectIdAzureDeployer, ids.roleAcrPush)
  scope: acr
  properties: {
    principalId: ids.ObjectIdAzureDeployer
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', ids.roleAcrPush)
    principalType: 'ServicePrincipal'
  }
}

output acrId string = acr.id
