param location string
param config object
param ids object

resource keyVaultResource 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: take(config.name,24)
  location: location
  properties: {
    sku: {
      family: 'A'
      name: config.skuName
    }
    tenantId: config.tenantId
    
    // Paramètres de sécurité importants
    enableRbacAuthorization: true      // Utilise le RBAC au lieu des Access Policies
    enabledForDeployment: true          // Autorise les VM à récupérer des certificats
    enabledForTemplateDeployment: true  // Autorise ARM/Bicep à récupérer des secrets
    enableSoftDelete: true              // Protection contre la suppression accidentelle
    softDeleteRetentionInDays: 7
    
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow' // Change en 'Deny' pour restreindre l'accès au réseau
    }
  }
}

resource secretSSH 'Microsoft.KeyVault/vaults/secrets@2023-07-01' existing = {
  parent: keyVaultResource
  name: 'vm-ssh-private-key'
}

// Permettre au runner gitlab de récuperer la clé ssh sur le keyvault
resource roleSecretsOfficerGitlab 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVaultResource.id, ids.ObjectIdAzureDeployer, ids.roleSecretsUserId)
  scope: secretSSH 
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', ids.roleSecretsUserId) 
    principalId: ids.ObjectIdAzureDeployer
    principalType: 'ServicePrincipal'
  }
}

// Autoriser l'administrateur d'administrer le keyvault
resource roleSecretsOfficerAdminUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVaultResource.id, ids.adminUserId, ids.roleSecretOfficerId)
  scope: keyVaultResource
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', ids.roleSecretOfficerId)
    principalId: ids.adminUserId
    principalType: 'User'
  }
}

output kvId string = keyVaultResource.id
