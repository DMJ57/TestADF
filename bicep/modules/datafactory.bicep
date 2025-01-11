@description('Name of the Data Factory')
param dataFactoryName string = 'datafactoryTEST'

@description('Location of the Data Factory')
param location string = resourceGroup().location

@description('Name of the Azure Storage Account that contains I/O & O/P data')
param storageAccountName string = 'adfstorageaccount'

@description('Name of the container in the Azure Storage Account')
param containerName string = 'adfcontainer'

var datafactoryLinkedServiceName = 'TestLinkedService'
var datafactoryDatasetName = 'TestDataset'
var datafactoryPipelineName = 'TestPipeline'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName}/default/${containerName}'
}

resource datafactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}

resource linkedService 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  name: '${datafactoryName}/${datafactoryLinkedServiceName}'
  properties: {
    type: 'AzureBlobStorage'
    typeProperties: {
      connectionString: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=[listKeys(resourceId('Microsoft.Storage/storageAccounts', storageAccountName), providers(\'Microsoft.Storage\', \'storageAccounts\').apiVersions[0]).keys[0].value];EndpointSuffix=core.windows.net'
    }
  }
}

resource dataset 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${datafactoryName}/${datafactoryDatasetName}'
  properties: {
    type: 'AzureBlob'
    linkedServiceName: {
      referenceName: datafactoryLinkedServiceName
      type: 'LinkedServiceReference'
    }
    typeProperties: {
      folderPath: 'adfcontainer'
      format: {
        type: 'TextFormat'
      }
    }
  }
}
