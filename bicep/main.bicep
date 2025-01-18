@description('Name of the Data Factory')
param dataFactoryName string = 'datafactoryTEST333'

@description('Location of the Data Factory')
param location string = resourceGroup().location

@description('Name of the Azure Storage Account that contains I/O & O/P data')
param storageAccountName string = 'demokomatsu'

@description('Name of the container in the Azure Storage Account')
param containerName string = 'adfcontainer'

param storageAccount1 string = 'Y4Fo0vh4xap7U+VravqaJftr++ToUycBATaNeOJ1eLNJZkKyU3e9qZZCIPeLoP03xZmwO/s8gHCc+ASt9ejhfw=='

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
  name: datafactoryLinkedServiceName
  parent: datafactory
  properties: {
    type: 'AzureBlobStorage'
    typeProperties: {
      connectionString: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount1};EndpointSuffix=core.windows.net'
    }
  }
}

resource dataset 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: datafactoryDatasetName
  parent: datafactory
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

resource pipeline 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: datafactoryPipelineName
  parent: datafactory
  properties: {
    activities: [
      {
        name: 'CopyFromBlobToBlob'
        type: 'Copy'
        inputs: [
          {
            referenceName: datafactoryDatasetName
            type: 'DatasetReference'
          }
        ]
        outputs: [
          {
            referenceName: datafactoryDatasetName
            type: 'DatasetReference'
          }
        ]
        typeProperties: {
          source: {
            type: 'BlobSource'
          }
          sink: {
            type: 'BlobSink'
          }
        }
      }
    ]
  }
}

output datafactoryId string = datafactory.id
output storageAccountId string = storageAccount.id
output storageContainerId string = storageContainer.id
output linkedServiceId string = linkedService.id
output datasetId string = dataset.id
