param location string 
param vmName string 
param vmSize string
param subnetId string
param adminUsername string 
@secure()
param adminPassword string 


resource  nic 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize  
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'shazcloud-vm-dev-uksouth'
      adminUsername: adminUsername
      adminPassword: adminPassword
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
resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  name: '${vm.name}/bootstrap'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/shazzi2k/azure-game-server-platform/main/scripts/bootstrap.sh'
      ]
      commandToExecute: 'bash bootstrap.sh'
    }
  }
}
