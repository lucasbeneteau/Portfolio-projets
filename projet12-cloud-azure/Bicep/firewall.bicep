param location string
param hubVnetName string
param skuFW string
param fwSubnetName string
param fwName string

resource firewallPip 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: 'pip-firewall'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2024-07-01' = {
  name: fwName
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: skuFW
    }
    ipConfigurations: [
      {
        name: 'fw-ipconfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', hubVnetName, fwSubnetName)
          }
          publicIPAddress: {
            id: firewallPip.id
          }
        }
      }
    ]
    firewallPolicy: {
      id: fwPolicy.id
    }
  }
}

var allowInternetRules array = [
  {
    name: 'allow-http-https'
    ruleType: 'NetworkRule'
    ipProtocols: [
      'TCP'
    ]
    sourceAddresses: [
      '*'
    ]
    destinationAddresses: [
      '*'
    ]
    destinationPorts: [
      '80'
      '443'
    ]
  }
]

resource fwPolicy 'Microsoft.Network/firewallPolicies@2024-07-01' = {
  name: 'fw-policy'
  location: location
}

resource fwRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-07-01' = {
  parent: fwPolicy
  name: 'default-group'
  properties: {
    priority: 100
    ruleCollections: [
      {
        name: 'allow-internet'
        priority: 100
        action: {
          type: 'Allow'
        }
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        rules: allowInternetRules
      }
    ]
  }
}




















/*
resource routeTable 'Microsoft.Network/routeTables@2024-07-01' = {
  name: 'rt-spoke'
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

resource subnetUpdate 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: cheminSubnet
  properties: {
    addressPrefix: frontendAddressPrefix
    routeTable: {
      id: routeTable.id
    }
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', frontendNsg)
    }
  }
}
*/
