@description('Resource Group of the existing Data Factory')
param resourceGroupName string
 
@description('Name of the existing Data Factory')
param dataFactoryName string
 
@description('Name of the linked service')
param linkedServiceName string
 
@description('Name of the Azure Storage Account that contains I/O & O/P data')
param storageAccountName string = 'adfstorageaccount'


param storageAccount1 string = 'Y4Fo0vh4xap7U+VravqaJftr++ToUycBATaNeOJ1eLNJZkKyU3e9qZZCIPeLoP03xZmwO/s8gHCc+ASt9ejhfw=='

 
module linkedServiceModule './modules/deploy-linked-service.bicep' = {
  name: 'linkedServiceDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    dataFactoryName: dataFactoryName
    linkedServiceName: linkedServiceName
    linkedServiceType: 'AzureBlobStorage'
    linkedServiceProperties: {
      connectionString: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount1};EndpointSuffix=core.windows.net'
    }
  }
}
 
