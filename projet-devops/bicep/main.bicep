// Paramétrage de base
param projectName string
param environment string
param location string = resourceGroup().location

//NOMMAGE
var prefix = '${projectName}-${environment}'
var names = {
  vnets: toObject(items(vnets), vnet => vnet.key, vnet => '${prefix}-${vnet.key}') // tableau cle valeur vnetName : prefix-vnetName
  nsgs: toObject(items(nsgs), nsg => nsg.key, nsg => 'nsg-${prefix}-${nsg.key}')
  kv: take('${prefix}-kv', 24) // 24 caractères maximum autorisés sur un keyvault
  natGatewayName: '${prefix}-natGateway'
  acr: '${projectName}${environment}acr'
}

//IDS roles et IDS service principal et user
var ids = {
  //
  roleVmAdminId: '1c0163c0-47e6-4577-8991-ea5c82e286e4'
  roleSecretOfficerId: 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
  roleSecretsUserId: '4633458b-17de-408a-b874-0445c86b69e6'
  roleAcrPull: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
  roleAcrPush: '8311e382-0749-4cb8-b61a-304f252e45ec'
  adminUserId: 'c8c8b37a-2b93-453b-9bb2-dc60fbf018fc'
  ObjectIdAzureDeployer: '7308f6b1-76d7-4040-87b1-0163b2b2f937'
}

//vnet
param vnets object

// VMS ####################################
param vms object

var ubuntu24 = { publisher: 'canonical', offer: 'ubuntu-24_04-lts', sku: 'server', version: 'latest' }

var vmDefaults = {
  web: {
    size: 'Standard_F1als_v7'
    image: ubuntu24
  }
  DB: {
    size: 'Standard_F1als_v7'
    image: ubuntu24
  }
}

var vmsConfig = toObject(items(vms), vm => vm.key, vm => {
  name: '${prefix}-vm-${vm.key}'
  username: 'azureuser'
  size: vmDefaults[vm.value.type].size
  image: vmDefaults[vm.value.type].image
  vnetName: names.vnets[vm.value.vnet]
  subnetName: vm.value.subnet
  publicIp: vm.value.publicIp
})

param adminPublicKey string
//FIN VMS ################################################

// Nsg
param nsgs object

// Keyvault
var keyvaultConfig = {
  name: names.kv
  skuName: 'standard'
  tenantId: subscription().tenantId
}

// ### MODULES ###
module nsgsDeploy 'modules/nsg.bicep' = {
  name: 'deploy-${prefix}-nsgs'
  params: {
    nsgNames: names.nsgs
    location: location
    nsgConfig: nsgs
  }
}

module VnetDeploy 'modules/vnet.bicep' = {
  name: 'deploy-${prefix}-vnets'
  params: {
    vnetNames: names.vnets
    config: vnets
    location: location
    nsgIds: nsgsDeploy.outputs.nsgIds
    natGatewayId: natgatewayDeploy.outputs.natGatewayId
  }
}

module nicAndVmsDeploy 'modules/nic-et-vms.bicep' = [
  for vm in items(vmsConfig): {
    name: 'deploy-${vm.value.name}'
    params: {
      vmConfig: vm.value
      location: location
      sshPublicKey: adminPublicKey
      kvId: keyvaultDeploy.outputs.kvId
      subnetIds: VnetDeploy.outputs.subnetIds
      acrId: acrDeploy.outputs.acrId
      ids: ids
    }
  }
]

module keyvaultDeploy 'modules/keyvault.bicep' = {
  name: 'deploy-${prefix}-keyvault'
  params: {
    location: location
    config: keyvaultConfig
    ids:ids
  }
}

module natgatewayDeploy 'modules/natgateway.bicep' = {
  name: 'deploy-${prefix}-natgateway'
  params: {
    location: location
    name: names.natGatewayName
  }
}

module acrDeploy 'modules/acr.bicep' = {
  name: 'deploy-${prefix}-acr'
  params:{
    location:location
    name: names.acr
    ids: ids
  }
}

output AcrName string = names.acr
