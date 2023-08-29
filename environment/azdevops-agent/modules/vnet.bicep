param location string
param name string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'sb-infra'
        properties: {
          addressPrefix: '10.0.16.0/23'
        }
      }
    ]
  }
}

output vNetName string = virtualNetwork.name
output infrastructureSubnetId string = virtualNetwork.properties.subnets[0].name
