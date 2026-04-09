// ### PARAMETRAGE ###

//Paramètres Généraux
param location string
param sshPublicKey string
param vms array
param spokes array
param vmSettings object
param loadBalancer object

// Choix déploiement ressources
param deployLB bool = true

// ### VARIABLES ###
var allspokesSubnets = flatten(map(spokes, s => s.subnets))
var frontendSubnet = first(filter(allspokesSubnets, s => s.name == 'frontend'))
var frontendSubnetName = frontendSubnet.name

// LoadBalancer
var loadBalancerName = loadBalancer.name
var backendPoolName = loadBalancer.backendPoolName
var probeHttpName = loadBalancer.probeHttpName


// ### MODULES ###
module nicAndVmsDeploy 'nic-et-vms.bicep' = [
  for (vm, i) in vms: {
    name: 'deploy-${vm.name}'
    params: {
      vmName: vm.name
      vmSize: vm.size
      image: vm.image
      location: location
      subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', vm.vnet, vm.subnet)
      adminUsername: vmSettings.username
      sshPublicKey: sshPublicKey
      publicIpEnabled: vm.publicIp
      privateIp: vm.privateIp
      loadBalancerName: loadBalancerName
      backendPoolName: backendPoolName
      deployLb: deployLB
      i: i
    }
    dependsOn: [LB]
  }
]

module LB 'loadbalancer.bicep' = if (deployLB) {
  name: 'deploy-lb'
  params: {
    loadBalancerName: loadBalancerName
    backendPoolName: backendPoolName
    frontendName: frontendSubnetName
    probeHttpName: probeHttpName
    location: location
    skuLB: 'Standard'
  }
}
