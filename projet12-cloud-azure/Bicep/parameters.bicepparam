using 'main.bicep'

var appGwSubnetPrefix = '10.0.1.0/24'

// Règles NSG
param nsgAppGwRules = [
  {
    name: 'AllowMyIp'
    priority: 300
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: ['80', '443']
    source: '79.84.201.128'
    destination: '*'
  }
  {
    name: 'AllowGatewayManager'
    priority: 100
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: ['65200-65535']
    source: 'GatewayManager'
    destination: '*'
  }
]
param nsgFrontendRules = [
  {
    name: 'AllowTrafficFromAppGw'
    priority: 100
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: ['80']
    source: appGwSubnetPrefix
    destination: '*'
  }
  {
    name: 'AllowBastionInbound'
    priority: 200
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: [
      '22'
      '3389'
    ]
    source: 'VirtualNetwork'
    destination: '*'
  }
  {
    name: 'AllowAzureLoadBalancerInBound'
    priority: 230
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: ['*']
    source: 'AzureLoadBalancer'
    destination: '*'
  }
  {
    name: 'AllowMyIp'
    priority: 250
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: ['*']
    source: '79.84.201.128'
    destination: '*'
  }
  {
    name: 'DenyAllinBound'
    priority: 1000
    direction: 'Inbound'
    access: 'Deny'
    protocol: '*'
    portRanges: ['*']
    source: '*'
    destination: '*'
  }
  {
    name: 'AllowTrafficToBackend'
    priority: 100
    direction: 'Outbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: ['*']
    source: '*'
    destination: '10.1.2.0/24'
  }
  {
    name: 'AllowOSUpdates'
    priority: 150
    direction: 'Outbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: ['443']
    source: '*'
    destination: 'Internet'
  }
]
param nsgBackendRules = [
  {
    name: 'AllowFrontendInbound'
    priority: 100
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: [
      '80'
      '443'
    ]
    source: '10.1.1.0/24'
    destination: '*'
  }
  {
    name: 'AllowBastionInbound'
    priority: 150
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: [
      '22'
      '3389'
    ]
    source: 'VirtualNetwork'
    destination: '*'
  }
  {
    name: 'AllowAzureLoadBalancerInBound'
    priority: 200
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: ['*']
    source: 'AzureLoadBalancer'
    destination: '*'
  }
  {
    name: 'DenyAllInbound'
    priority: 900
    direction: 'Inbound'
    access: 'Deny'
    protocol: '*'
    portRanges: ['*']
    source: '*'
    destination: '*'
  }
  {
    name: 'AllowOSUpdates'
    priority: 110
    direction: 'Outbound'
    access: 'Allow'
    protocol: 'Tcp'
    portRanges: ['443']
    source: '*'
    destination: 'Internet'
  }
  {
    name: 'DenyAllOutbound'
    priority: 900
    direction: 'Outbound'
    access: 'Deny'
    protocol: '*'
    portRanges: ['*']
    source: '*'
    destination: '*'
  }
]

// HUB
param hub = { 
  vnetName: 'vnet-hub'
  address: [
    '10.0.0.0/16'
  ]
  subnets: [
    {
      name: 'AppGwSubnet'
      prefix: [
        appGwSubnetPrefix
      ]
      appGwName: 'appGateway'
      nsg: 'nsg-appGateway'
    }
    {
      name: 'AzureFirewallSubnet'
      prefix: [
        '10.0.2.0/24'
      ]
      firewallName: 'firewall-hub'
    }
    {
      name: 'AzureBastionSubnet'
      prefix: [
        '10.0.3.0/24'
      ]
      bastionName: 'bastion'
    }
  ]
}

// SPOKES
param spokes = [
  {
    vnetName: 'vnet-spoke-1'
    address: [
      '10.1.0.0/16'
    ]
    subnets: [
      {
        name: 'frontend'
        prefix: [
          '10.1.1.0/24'
        ]
        nsg: 'nsg-frontend'
        routeTable: 'rt-spoke'
        natGatewayName: 'natGateway'
      }
      {
        name: 'backend'
        prefix: [
          '10.1.2.0/24'
        ]
        nsg: 'nsg-backend'
      }
    ]
  }
]

param loadBalancer = {
  name: 'loadBalancer'
  backendPoolName: 'backendPool-1'
  probeHttpName: 'http-probe'
}

// VMS
param vmSettings = {
    username: 'azureuser'
  }
param vms = [
  {
    name: 'vm-frontend-01'
    vnet: 'vnet-spoke-1'
    subnet: 'frontend'
    privateIp: '10.1.1.4'
    size: 'Standard_F1als_v7'
    image: {
      publisher: 'canonical'
      offer: 'ubuntu-24_04-lts'
      sku: 'server'
      version: 'latest'
    }
    publicIp: false
  }
  {
    name: 'vm-frontend-02'
    vnet: 'vnet-spoke-1'
    subnet: 'frontend'
    privateIp:'10.1.1.5'
    size: 'Standard_F1als_v7'
    image: {
      publisher: 'canonical'
      offer: 'ubuntu-24_04-lts'
      sku: 'server'
      version: 'latest'
    }
    publicIp: false
  }
]

param sshPublicKey = 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgF+et11aM/C/wJTzNYWun9MBV9TYK3K6b6iCPq8ST6 azure-vm'
