param location string 
param vnetName string
param addressPrefix string  
param subnetName string
param subnetPrefix string
param nsgName string
param vmName string
param adminUsername string
@secure()
param adminPassword string
param vmSkuList array 


module nsg 'modules/nsg.bicep' = {
  name: 'nsgModule'
  params: {
    location: location
    nsgName: nsgName


  }
}

module vnet 'modules/vnet.bicep' = {
  name: 'vnetModule'
  params: {
    location: location
    vnetName: vnetName
    addressPrefix: addressPrefix
    subnetName: subnetName
    subnetPrefix: subnetPrefix
    nsgId: nsg.outputs.nsgId
    
  }
}

module vm 'modules/vm.bicep' = {
  name: 'vmModule'
  params: {
    location: location
    vmName: vmName
    vmSize: vmSkuList[0]
    subnetId: vnet.outputs.subnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
