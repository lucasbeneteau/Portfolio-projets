param location string
param name string

resource natGatewayPip 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: 'pip-natGateway'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// NAT Gateway
resource natGatewayResource 'Microsoft.Network/natGateways@2024-07-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIpAddresses: [
      {
        id: natGatewayPip.id
      }
    ]
    idleTimeoutInMinutes: 10
  }
}

output natGatewayId string = natGatewayResource.id
