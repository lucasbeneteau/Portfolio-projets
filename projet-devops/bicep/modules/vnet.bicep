param config object
param location string
param vnetNames object
param nsgIds object
param natGatewayId string

resource vnetResource 'Microsoft.Network/virtualNetworks@2024-07-01' = [
  for vnet in items(config): {
    name: vnetNames[vnet.key]
    location: location
    properties: {
      addressSpace: {
        addressPrefixes: vnet.value.address
      }
      subnets: [
        for subnet in items(vnet.value.?subnets ?? {}): {
          name: subnet.key
          properties: {
            addressPrefixes: subnet.value.prefix
            ...(subnet.value.?nsgKey != null
              ? {
                  networkSecurityGroup: {
                    id: nsgIds[subnet.value.nsgKey]
                  }
                }
              : {})
              ...(subnet.value.?nategateway == true
              ? {
                  natGateway:  {
                    id: natGatewayId
                  }
                }
              : {})
            privateEndpointNetworkPolicies: 'Disabled'
            privateLinkServiceNetworkPolicies: 'Enabled'
            defaultOutboundAccess: true
          }
        }
      ]
    }
  }
]

// On récupere les ids des subnets
output subnetIds object = toObject(
  flatten(map(items(config), vnet => map(items(vnet.value.?subnets ?? {}), subnet => {
    uniqueKey: '${vnetNames[vnet.key]}-${subnet.key}'
    vnetKey: vnet.key
    subnetName: subnet.key
  }))),
  item => item.uniqueKey, 
  item => resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNames[item.vnetKey], item.subnetName)
)

