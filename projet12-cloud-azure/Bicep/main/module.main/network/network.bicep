// ### PARAMETRAGE ###

// Choix déploiement ressources
param deployappGw bool = false
param deployNatgateway bool = true
param deployBastion bool = false
param deployFirewall bool = false

// Paramètres généraux
param location string
param hub object
param spokes array
param vms array

// NsgRules
param nsgAppGwRules array
param nsgFrontendRules array
param nsgBackendRules array

// ### VARIABLES ###

// Spokes Subnets 
var allspokesSubnets = flatten(map(spokes, s => s.subnets))
var frontendSubnet = first(filter(allspokesSubnets, s => s.name == 'frontend'))
var backendSubnet = first(filter(allspokesSubnets, s => s.name == 'backend'))

// Hub Subnets
var fwSubnet = first(filter(hub.subnets, s => s.?firewallName != null))
var bastionSubnet = first(filter(hub.subnets, s => s.?bastionName != null))
var appGwSubnet = first(filter(hub.subnets, s => s.?appGwName != null))

// Nsg
var frontendNsgName = frontendSubnet.?nsg
var backendNsgName = backendSubnet.?nsg
var appGwNsgName = appGwSubnet.?nsg

// Application Gateway
var appGwName = appGwSubnet.appGwName
var appGwSubnetName = appGwSubnet.name
var vmsPrivateIps = [ 
  for vm in vms: {
   IpAddress:vm.privateIp 
  }
]

// Nat Gateway
var natGatewayName = frontendSubnet.natGatewayName

// Bastion
var bastionName = bastionSubnet.bastionName
var bastionSubnetName = bastionSubnet.name

// Firewall
var fwName = fwSubnet.firewallName
var fwSubnetName = fwSubnet.name

// RouteTable
var routeTableName = frontendSubnet.?routeTable


// ### MODULES ###

module nsgAppGw 'nsg.bicep' = {
  name: 'deploy-nsg-appGw'
  params: {
    nsgName: appGwNsgName
    location: location
    rules: nsgAppGwRules
  }
}
module nsgFrontend 'nsg.bicep' = {
  name: 'deploy-nsg-frontend'
  params: {
    nsgName: frontendNsgName
    location: location
    rules: nsgFrontendRules
  }
}
module nsgBackend 'nsg.bicep' = {
  name: 'deploy-nsg-backend'
  params: {
    nsgName: backendNsgName
    location: location
    rules: nsgBackendRules
  }
}

module hubVnet 'vnet.bicep' = {
  name: 'deploy-vnet-${hub.vnetName}'
  params: {
    vnetName: hub.vnetName
    address: hub.address
    location: location
  }
}
module hubSubnets 'subnet.bicep' = {
  name: 'deploy-hubSubnets'
  params: {
    vnetName: hub.vnetName
    subnets: hub.subnets
    deployFw: deployFirewall
    deployNatGw: deployNatgateway
  }
  dependsOn: [
    hubVnet
    nsgAppGw
  ]
}

module spokesVnet 'vnet.bicep' = [
  for spoke in spokes: {
    name: 'deploy-${spoke.vnetName}'
    params: {
      vnetName: spoke.vnetName
      address: spoke.address
      location: location
    }
  }
]
module spokesSubnets 'subnet.bicep' = [
  for spoke in spokes: {
    name: 'deploy-subnets-${spoke.vnetName}'
    params: {
      vnetName: spoke.vnetName
      subnets: spoke.subnets
      deployFw: deployFirewall
      deployNatGw: deployNatgateway
    }
    dependsOn: [
      spokesVnet
      nsgFrontend
      nsgBackend
      routetable
      natgateway
    ]
  }
]

module peering 'peering.bicep' = [
  for spoke in spokes: {
    name: 'deploy-peering-ToAndFrom-${spoke.vnetname}'
    params: {
      hubVnetName: hub.vnetName
      spokeVnetName: spoke.vnetName
      allowGatewayTransit: false
      useRemoteGateways: false
    }
    dependsOn: [
      spokesSubnets
      hubSubnets
    ]
  }
]

module appGw 'appGw.bicep' = if (deployappGw) {
  name: 'deploy-appGw'
  params: {
    location: location
    appGwName: appGwName
    hubVnetName: hub.vnetName
    appGwSubnetName: appGwSubnetName
    vmsPrivateIps : vmsPrivateIps
  }
  dependsOn: [
    hubSubnets
  ]
}

module natgateway 'natgateway.bicep' = if (deployNatgateway) {
  name: 'deploy-natGateway'
  params: {
    natGatewayName: natGatewayName
    location: location
  }
}

module bastion 'bastion.bicep' = if (deployBastion) {
  name: 'deploy-bastion'
  params: {
    bastionName: bastionName
    bastionSubnetName: bastionSubnetName
    location: location
    skuBastion: 'Basic'
    hubVnetName: hub.vnetName
  }
  dependsOn: [
    hubSubnets
  ]
}

module firewall 'firewall.bicep' = if (deployFirewall) {
  name: 'deploy-firewall'
  params: {
    fwName: fwName
    fwSubnetName: fwSubnetName
    location: location
    hubVnetName: hub.vnetName
    skuFW: 'Standard'
  }
  dependsOn: [
    hubSubnets
  ]
}

module routetable 'routetable.bicep' = if (deployFirewall) {
  name: 'deploy-routetable'
  params: {
    routeTableName: routeTableName
    location: location
    fwName: fwName
  }
  dependsOn: [
    firewall
  ]
}
