using 'main.bicep'

param projectName = 'monapp'
param environment = 'dev'

// Règles NSG
param nsgs = {
  web: [
    {
      name: 'AllowPublicInbound'
      priority: 100
      direction: 'Inbound'
      access: 'Allow'
      protocol: 'Tcp'
      portRanges: [
        '80'
        '443'
        '22'
      ]
      source: '*'
      destination: '*'
    }
    {
      name: 'DenyAllInbound'
      priority: 4000
      direction: 'Inbound'
      access: 'Deny'
      protocol: '*'
      portRanges: ['*']
      source: '*'
      destination: '*'
    }
    // WEB OUTBOUND
    {
      name: 'AllowEntraOut'
      priority: 100
      direction: 'Outbound'
      access: 'Allow'
      protocol: 'Tcp'
      portRanges: ['443']
      source: '*'
      destination: 'AzureActiveDirectory'
    }
    {
      name: 'AllowInternetOut'
      priority: 200
      direction: 'Outbound'
      access: 'Allow'
      protocol: 'Tcp'
      portRanges: ['443','80']
      source: '*'
      destination: 'Internet'
    }
    {
      name: 'AllowDBOut'
      priority: 300
      direction: 'Outbound'
      access: 'Allow'
      protocol: 'Tcp'
      portRanges: [
        '3306'
        '5432'
      ]
      source: '*'
      destination: '10.1.2.0/24'
    }
    {
      name: 'DenyAllOutbound'
      priority: 4000
      direction: 'Outbound'
      access: 'Deny'
      protocol: '*'
      portRanges: ['*']
      source: '*'
      destination: '*'
    }
  ]
  DB: [
    {
      name: 'AllowDBFromWeb'
      priority: 100
      direction: 'Inbound'
      access: 'Allow'
      protocol: 'Tcp'
      portRanges: [
        '3306'
        '5432'
      ]
      source: '10.1.1.0/24'
      destination: '*'
    }
    {
      name: 'DenyAllInbound'
      priority: 4000
      direction: 'Inbound'
      access: 'Deny'
      protocol: '*'
      portRanges: ['*']
      source: '*'
      destination: '*'
    }
    // DB:OUTBOUND
    {
      name: 'AllowAADOutbound'
      priority: 100
      direction: 'Outbound'
      access: 'Allow'
      protocol: 'Tcp'
      portRanges: ['443']
      source: '*'
      destination: 'AzureActiveDirectory'
    }
    {
      name: 'AllowInternetout'
      priority: 200
      direction: 'Outbound'
      access: 'Allow'
      protocol: '*'
      portRanges: ['443','80']
      source: '*'
      destination: 'Internet'
    }
    {
      name: 'DenyAllOutbound'
      priority: 4000
      direction: 'Outbound'
      access: 'Deny'
      protocol: '*'
      portRanges: ['*']
      source: '*'
      destination: '*'
    }
  ]
}

param vnets = {
  vnet01: {
    address: [
      '10.1.0.0/16'
    ]
    subnets: {
      publicSubnet: {
        prefix: [
          '10.1.1.0/24'
        ]
        nsgKey: 'web'
        natgateway: true
      }
      privateSubnet: {
        prefix: [
          '10.1.2.0/24'
        ]
        nsgKey: 'DB'
        natgateway: true
      }
    }
  }
  vnet02: {
    address: [
      '10.2.0.0/16'
    ]
  }
}

param vms = {
  'web-01': {
    type: 'web'
    publicIp: true
    vnet: 'vnet01'
    subnet: 'publicSubnet'
  }
  'DB-01': {
    type: 'DB'
    publicIp: true
    vnet: 'vnet01'
    subnet: 'privateSubnet'
  }
}

param adminPublicKey = 'ECRASE PAR RUNNER GITLAB'
