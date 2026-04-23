param nsgNames object
param location string
param nsgConfig object

resource nsgResource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = [
  for nsg in items(nsgConfig): {
    name: nsgNames[nsg.key]
    location: location
    properties: {
      securityRules: [
        for rule in nsg.value: {
          name: rule.name
          properties: {
            priority: rule.priority
            direction: rule.direction
            access: rule.access
            protocol: rule.protocol
            sourcePortRange: '*'
            sourceAddressPrefix: rule.source
            destinationAddressPrefix: rule.destination
            // Gestion dynamique du port unique vs liste de ports
            ...(length(rule.portRanges) == 1
              ? { destinationPortRange: rule.portRanges[0] }
              : { destinationPortRanges: rule.portRanges })
          }
        }
      ]
    }
  }
]
output nsgIds object = toObject(items(nsgConfig), nsg => nsg.key, nsg => resourceId('Microsoft.Network/networkSecurityGroups', nsgNames[nsg.key]))
