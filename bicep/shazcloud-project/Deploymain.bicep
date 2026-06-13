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
param keyVaultName string
param workspaceName string









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
resource deployedVm 'Microsoft.Compute/virtualMachines@2024-03-01' existing = {
  scope: resourceGroup()
  name: vmName
}

module keyvault 'modules/keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    location: location
    vaultName: keyVaultName
    
    
  }
}
resource keyVaultExisting 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: keyVaultName
}

resource kvSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(
    resourceGroup().id,
    vmName,
    'KeyVaultSecretsUser'
  )

  scope: keyVaultExisting

  properties: {
    principalId: vm.outputs.principalId

    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    )

    principalType: 'ServicePrincipal'
  }
}
module logAnalytics 'modules/loganalytics.bicep' = {
  name: 'workspaceModule'
  params: {
    location: location
    workspaceName: workspaceName
  }
}
module dcr 'modules/DCR.bicep' = {
  name: 'dcrModule'
  params: {
    location: location
    workspaceId: logAnalytics.outputs.logAnalyticsId
  }
}
resource dcrassociation 'Microsoft.Insights/dataCollectionRuleAssociations@2024-03-11' = {
  name: 'shazcloud-dcr-association'
  scope: deployedVm
  properties: {
    dataCollectionRuleId: dcr.outputs.dcrId
  }
  dependsOn: [
    vm
  ]
}
