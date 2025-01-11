@description('Resources location')
param location string = resourceGroup().location

//----------- Function App Parameters ------------

//----------- Key Vault Parameters ------------
@description('Key Vault name')
@minLength(3)
@maxLength(30)
param myKeyVault string = 'komatsuKeyvault33'

@description('keyVault SKU')
@allowed([
  'standard'
  'Premium'
])
param keyVaultSku string = 'standard'

@description('Key Vault Tenant ID')
@minLength(3)
@maxLength(50)
param tenantId string = '351ea326-1a66-4da2-addd-15d37c541283'




//----------- Storage Account Parameters ------------
@description('Function Storage Account name')
@minLength(3)
@maxLength(24)
param storageAccountName string = 'komatsu33'

@description('Function Storage Account SKU')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageAccountSku string = 'Standard_LRS'

var buildNumber = uniqueString(resourceGroup().id)

//----------- Storage Account Deployment ------------
module storageAccountModule 'modules/storage.bicep' = {
  name: 'stvmdeploy-storage-${buildNumber}'
  params: {
    name: storageAccountName
    sku: storageAccountSku
    location: location
  }
}

// //----------- App Service Deployment ------------

// param appServicePlanName string = 'myAppServicePlan'
// param appServiceName string = 'myAppService'

// module appServicePlan 'modules/appservice.bicep' = {
//   name: 'appServicePlanDeployment'
//   params: {
//     location: location
//     appServicePlanName: appServicePlanName
//   }
// }

// resource appService 'Microsoft.Web/sites@2021-02-01' = {
//   name: appServiceName
//   location: location
//   properties: {
//     serverFarmId: appServicePlan.outputs.appServicePlanId  // Referencing the App Service Plan ID output from the module
//       }
// }

//----------- KeyVault Deployment ------------
module keyVaultModule 'modules/keyvault.bicep' = {
  name: 'stvmdeploy-keyvault-${buildNumber}'
  params: {
    keyVaultName: myKeyVault
    skuName: keyVaultSku
    location: location
    tenantId: tenantId
  }
}



