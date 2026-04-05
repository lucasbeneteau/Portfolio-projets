param hubVnetName string
param spokeVnetName string
param allowGatewayTransit bool
param useRemoteGateways bool


resource spokeVnet 'Microsoft.Network/virtualNetworks@2024-07-01' existing = {
  name: spokeVnetName
}

resource hubVnet 'Microsoft.Network/virtualNetworks@2024-07-01' existing = {
  name: hubVnetName
}

resource peeringHubToSpokes 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-07-01' = {
  parent: hubVnet
  name: '${hubVnetName}-To-${spokeVnetName}'
  properties: {
    remoteVirtualNetwork: {
      id: spokeVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
  }
}

resource peeringSpokesToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-07-01' = {
  parent: spokeVnet
  name: '${spokeVnetName}-To-${hubVnetName}'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
  }
  dependsOn:[
    peeringHubToSpokes
  ]
}
