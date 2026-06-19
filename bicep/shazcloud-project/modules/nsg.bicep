
param location string
param  nsgName string



resource NSG 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowSSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '77.98.185.51/32'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowHTTP'
        properties: {
          description: 'testflask allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '5000'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
      
        }
      }
      {
        name: 'zomboidports'
        properties: {
          description: 'zomboid ports allow'
          protocol: 'UDP'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '8767'
            '8766'
            '16261'
            '16262'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'factorioports'
        properties: {
          description: 'factorio ports allow'
          protocol: 'UDP'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '34197'
            
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: '7days2dieportsudp'
        properties: {
          description: '7 days to die ports allow'
          protocol: 'UDP'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '26900'
            '26901'
            '26902'
            '26903'

          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: '7days2dieportstcp'
        properties: {
          description: '7 days to die ports allow'
          protocol: 'TCP'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '26900'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'valheimports'
        properties: {
          description: 'valheim ports allow'
          protocol: 'UDP'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '2456'
            '2457'
            '2458'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}
output nsgId string = NSG.id
