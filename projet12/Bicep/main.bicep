param location string = resourceGroup().location

param vnetName string
param vnetAddress array
param subnets array

param nsgName string
param pipName string

param SubnetFrontName string
param nicNamesSubnetFront array

module network 'network.bicep' = {
    name: 'networkDeploy'
    params:{
        vnetName: vnetName
        vnetAddress: vnetAddress
        subnets: subnets
        location: location
        nsgName: nsgName
        pipName: pipName
        SubnetFrontName: SubnetFrontName
        nicNamesSubnetFront: nicNamesSubnetFront
    }
}

param vms array
param adminUsername string
@secure()
param adminPassword string

module compute 'compute.bicep' = {
    name: 'computeDeploy'
    params:{
        location: location
        vms: vms
        adminUsername: adminUsername
        adminPassword: adminPassword
        nicIds: network.outputs.nicIds
    }
}
