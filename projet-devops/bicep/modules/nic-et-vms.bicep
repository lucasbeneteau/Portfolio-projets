param vmConfig object
param location string
param sshPublicKey string
param kvId string
param subnetIds object
param acrId string
param ids object

resource pip 'Microsoft.Network/publicIPAddresses@2024-07-01' = if (vmConfig.publicIp) {
  name: 'pip-${vmConfig.name}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// NIC
resource nicResource 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: 'nic-${vmConfig.name}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetIds['${vmConfig.vnetName}-${vmConfig.subnetName}']
          }
          privateIPAllocationMethod: 'Dynamic'
          ...(vmConfig.publicIp
            ? {
                publicIPAddress: {
                  id: pip.id
                }
              }
            : {})
        }
      }
    ]
  }
}

resource vmResource 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmConfig.name
  location: location
  identity: {
    type: 'SystemAssigned' 
  }
  properties: {
    hardwareProfile: {
      vmSize: vmConfig.size
    }
    osProfile: {
      computerName: vmConfig.name
      adminUsername: vmConfig.username
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${vmConfig.username}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: vmConfig.image
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicResource.id
        }
      ]
    }
  }
}

// 2. On installe l'extension de login Entra ID pour passer par RBAC au lieu de ssh directement
resource entraLoginExtension 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = {
  parent: vmResource
  name: 'AADSSHLoginForLinux' // Nom standard pour Linux
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: 'AADSSHLoginForLinux'
    typeHandlerVersion: '1.0'
  }
}

// je me donne le role d'admin sur la vm
resource vmLoginRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(vmResource.id, ids.adminUserId, ids.roleVmAdminId)
  scope: vmResource 
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', ids.roleVmAdminId)
    principalId: ids.adminUserId 
    principalType: 'User'
  }
}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: last(split(kvId, '/'))
}

resource secretPourVmWeb 'Microsoft.KeyVault/vaults/secrets@2023-07-01' existing = {
  parent: kv
  name: 'secretTest'
}

//Donner role pour chercher le secret "secretTest" dans le keyvault
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kvId, vmResource.id, ids.roleSecretsUserId)
  scope:secretPourVmWeb
  properties:{
    principalId:vmResource.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', ids.roleSecretsUserId)
    principalType:'ServicePrincipal'
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2025-11-01' existing = {
  name: last(split(acrId, '/'))
}

// Permettre aux vms de pull une image de l'acr
resource acrPullAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acrId, vmResource.id, ids.roleAcrPull)
  scope: acr
  properties: {
    principalId: vmResource.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', ids.roleAcrPull)
    principalType: 'ServicePrincipal'
  }
}
