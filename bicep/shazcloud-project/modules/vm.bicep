
param location string 
param vmName string 
param vmSize string
param subnetId string
param adminUsername string 
@secure()
param adminPassword string 


resource publicIP 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: '${vmName}-pip'
  location: location
  sku: {
    name: 'standard'
  }
  properties: {
    publicIPAllocationMethod: 'static'
  }
}

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
          publicIPAddress: {
            id: publicIP.id
          }
        }
        
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
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
  parent: vm
  name: 'bootstrap'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/shazzi2k/azure-game-server-platform/master/scripts/bootstrap.sh'
      ]
      commandToExecute: 'bash bootstrap.sh'
    }
  }
}
resource amaextension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: vm
  name: 'AMAlinuxAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'azureMonitorLinuxAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}
output vmId string = vm.id
output principalId string = vm.identity.principalId
