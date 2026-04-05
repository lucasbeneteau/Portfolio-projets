param location string = resourceGroup().location

// Paramètres Network
param hub object
param spokes array

// NSG
param nsgAppGwRules array
param nsgFrontendRules array
param nsgBackendRules array

//Paramètres Compute
param vms array
param vmSettings object
param sshPublicKey string

param loadBalancer object


//NETWORK
module network 'network.bicep' = {
    name:'Deploy-network'
    params: {
        location: location
        hub: hub
        spokes: spokes
        vms: vms
        nsgAppGwRules: nsgAppGwRules
        nsgFrontendRules: nsgFrontendRules
        nsgBackendRules: nsgBackendRules
    }

}

//COMPUTE
module compute 'compute.bicep' = {
    name:'Deploy-compute'
    params: {
        location: location
        vmSettings: vmSettings
        vms: vms
        spokes: spokes
        sshPublicKey: sshPublicKey
        loadBalancer: loadBalancer 
    }
    dependsOn: [
        network
    ]
}

