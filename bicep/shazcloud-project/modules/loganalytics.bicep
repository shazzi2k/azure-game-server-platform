param location string
param workspaceName string


resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {name: 'PerGB2018'}
    retentionInDays: 30
  }
}
output logAnalyticsId string = logAnalytics.id
output logAnalyticsName string = logAnalytics.name
