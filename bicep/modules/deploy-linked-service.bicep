@description('Name of the existing Data Factory')
param dataFactoryName string
 
@description('Name of the linked service')
param linkedServiceName string
 
@description('Type of the linked service (e.g., AzureBlobStorage, AzureSqlDatabase, etc.)')
param linkedServiceType string
 
@description('Properties of the linked service')
param linkedServiceProperties object
 
resource linkedService 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: '${dataFactoryName}/${linkedServiceName}'
  properties: {
    type: linkedServiceType
    typeProperties: linkedServiceProperties
  }
}
