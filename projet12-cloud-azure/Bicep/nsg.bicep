param nsgName string
param location string
param rules array

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      for rule in rules: {
        name: rule.name
        properties: {
          priority: rule.priority
          direction: rule.direction
          access: rule.access
          protocol: rule.protocol
          sourcePortRange: '*'
          sourceAddressPrefix: rule.source
          destinationAddressPrefix: rule.destination
          ...(length(rule.portRanges) == 1
            ? {
                destinationPortRange: rule.portRanges[0]
              }
            : {
                destinationPortRanges: rule.portRanges
              })
        }
      }
    ]
  }
}
