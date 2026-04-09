param vmName string
param location string
param subnetId string
param adminUsername string
param sshPublicKey string
param vmSize string
param image object
param publicIpEnabled bool = false
param privateIp string
param deployLb bool
param loadBalancerName string
param backendPoolName string
param i int

resource pip 'Microsoft.Network/publicIPAddresses@2024-07-01' = if (publicIpEnabled) {
  name: 'pip-${vmName}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

var backendPoolId = deployLb
  ? resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, backendPoolName)
  : null

// NIC
resource nic 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: 'nic-${vmName}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Static'
          privateIPAddress: privateIp
          ...(publicIpEnabled
            ? {
                publicIPAddress: {
                  id: pip.id
                }
              }
            : {})
          ...(deployLb
            ? {
                loadBalancerBackendAddressPools: [
                  {
                    id: backendPoolId
                  }
                ]
              }
            : {})
        }
      }
    ]
  }
}

// VM
resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: image.publisher
        offer: image.offer
        sku: image.sku
        version: image.version
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

resource customScript 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = {
  name: 'customScript'
  location: resourceGroup().location
  parent: vm
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'sudo apt-get update -y && sudo apt-get install -y nginx && sudo systemctl enable nginx && sudo systemctl start nginx && echo "Bienvenue sur la VM numero ${i}" | sudo tee /var/www/html/index.html'
    }
  }
}
