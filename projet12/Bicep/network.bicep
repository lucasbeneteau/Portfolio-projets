param location string
param vnetName string

param vnetAddress array

resource vnet_ressource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddress
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

param subnets array

resource vnetName_Subnets 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = [
  for subnet in subnets: {
    parent: vnet_ressource
    name: subnet.name
    properties: {
      addressPrefixes: subnet.prefix
      privateEndpointNetworkPolicies: 'Disabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      defaultOutboundAccess: false
      networkSecurityGroup: subnet.name == SubnetFrontName ? {
        id: nsg.id
    } :null
    }
  }
]

param nsgName string

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          priority: 300
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '79.84.201.128'
          destinationAddressPrefix: '*'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

param pipName string

resource pip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: pipName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

param nicNamesSubnetFront array
param SubnetFrontName string
var subnetNames = [for s in subnets: s.name]
var frontSubnetIndex = indexOf(subnetNames,SubnetFrontName)

resource subnetfront_nic_resources 'Microsoft.Network/networkInterfaces@2024-07-01' = [
  for nicName in nicNamesSubnetFront: {
    name: nicName
    location: location
    properties: {
      ipConfigurations: [
        {
          name: 'ipconfig1'
          properties: {
            privateIPAllocationMethod: 'Dynamic'
            subnet: {
              id: vnetName_Subnets[frontSubnetIndex].id
            }
            primary: true
          }
        }
      ]
      enableAcceleratedNetworking: false
      enableIPForwarding: false
    }
  }
]

output nicIds array = [for (nic, i) in nicNamesSubnetFront: subnetfront_nic_resources[i].id]
