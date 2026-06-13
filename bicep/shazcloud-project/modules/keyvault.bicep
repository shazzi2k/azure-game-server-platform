param location string
param vaultName string



resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: vaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: []
  }
}
resource secret1 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  parent: keyVault
  name: 'secret1'
  properties: {
    value: '33471623'
  }
}
output vaultId string = keyVault.id
output vaultName string = keyVault.name
