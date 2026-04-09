param location string
param routeTableName string
param fwName string

resource firewall 'Microsoft.Network/azureFirewalls@2024-07-01' existing = {
  name: fwName
}

resource routeTable 'Microsoft.Network/routeTables@2024-07-01' = {
  name: routeTableName
  location: location
  properties: {
    routes: [
      {
        name: 'default-route'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewall.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}
