param location string
param vnetName string 
param addressPrefix string
param subnetName string
param subnetPrefix string 
param nsgId string


resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: nsgId
          }
        }
      }
    ]

  }
}
output subnetId string = vnet.properties.subnets[0].id
