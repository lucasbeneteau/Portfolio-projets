param vnetName string
param subnets array
param deployFw bool
param deployNatGw bool

resource Vnet 'Microsoft.Network/virtualNetworks@2024-07-01' existing = {
  name: vnetName
}

@batchSize(1)
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = [
  for s in subnets: {
    parent: Vnet
    name: s.name
    properties: {
      addressPrefixes: s.prefix
      ...(s.?nsg != null
        ? {
            networkSecurityGroup: {
              id: resourceId('Microsoft.Network/networkSecurityGroups', s.nsg)
            }
          }
        : {})
      ...((s.?routeTable != null) && deployFw
        ? {
            routeTable: {
              id: resourceId('Microsoft.Network/routeTables', s.routeTable)
            }
          }
        : {})
      ...((s.?natGatewayName != null) && deployNatGw
        ? {
            natGateway: {
              id: resourceId('Microsoft.Network/natGateways', s.natGatewayName)
            }
          }
        : {})
      privateEndpointNetworkPolicies: 'Disabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      defaultOutboundAccess: true
    }
  }
]
