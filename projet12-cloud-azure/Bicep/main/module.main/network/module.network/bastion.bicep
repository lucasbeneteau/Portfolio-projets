param location string
param skuBastion string
param hubVnetName string
param bastionName string
param bastionSubnetName string

resource bastionPip 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: 'pip-bastion'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2024-07-01' = {
  name: bastionName
  sku: {
    name: skuBastion
  }
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'bastion-ipconfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets',hubVnetName,bastionSubnetName)
          }
          publicIPAddress: {
            id: bastionPip.id
          }
        }
      }
    ]
  }
}
