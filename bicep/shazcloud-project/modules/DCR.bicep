param location string
param workspaceId string

resource dcr 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: 'shazcloud-dcr'
  location: location
  properties: {
    dataSources: {
       syslog:[
        {
          name: 'syslogDataSource'
          streams: [
            'Microsoft-Syslog'
          ]
          facilityNames: [
              '*'
            ]
            logLevels: [
              '*' 
            ]
          }
        


      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: 'logAnalyticsDestination'
          workspaceResourceId: workspaceId
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Syslog'
        ]
        destinations: [
          'logAnalyticsDestination'
        ]
      }
    ]
  }
}
output dcrId string = dcr.id
