param location string
@description('The administrator username for the virtual machine')
param adminUsername string
@secure()
@description('The administrator password for the virtual machine')
param adminPassword string

param vms array
param nicIds array

resource virtualMachine 'Microsoft.Compute/virtualMachines@2023-03-01' = [
  for (vm, i) in vms: {
    name: vm
    location: location
    properties: {
      hardwareProfile: {
        vmSize: 'Standard_F1as_v7'
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: nicIds[i]
            properties: {
              primary: false
            }
          }
        ]
      }
      osProfile: {
        adminPassword: adminPassword
        adminUsername: adminUsername
        computerName: vm
        linuxConfiguration: {
          disablePasswordAuthentication: false
        }
      }
      storageProfile: {
        imageReference: {
          publisher: 'Canonical'
          offer: 'ubuntu-24_04-lts'
          sku: 'server'
          version: 'latest'
        }
        osDisk: {
          caching: 'ReadWrite'
          createOption: 'FromImage'
          writeAcceleratorEnabled: false
        }
      }
    }
  }
]
