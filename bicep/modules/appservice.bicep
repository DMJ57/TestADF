// @description('Location for all resources')
// param location string = resourceGroup().location

// @description('Name of the App Service Plan')
// param appServicePlanName string

// @description('Name of the App Service')
// param appName string

// @description('SKU for the App Service Plan')
// param appServiceSkuName string = 'B1' // Default SKU (Basic tier)

// @description('Tier for the App Service Plan')
// param appServiceSkuTier string = 'Basic' // Default tier

// @description('Runtime stack for the App Service')
// param linuxFxVersion string = 'DOTNETCORE|6.0' // Change as per runtime requirements

// @description('Enable HTTPS Only')
// param httpsOnly bool = true

// @description('Environment tag for the resources')
// param environment string = 'production'

// // App Service Plan
// resource appServicePlan 'Microsoft.Web/serverFarms@2022-09-01' = {
//   name: appServicePlanName
//   location: location
//   sku: {
//     name: appServiceSkuName
//     tier: appServiceSkuTier
//   }
//   properties: {
//     reserved: true // Reserved for Linux apps
//   }
// }

// // App Service
// resource appService 'Microsoft.Web/sites@2022-09-01' = {
//   name: appName
//   location: location
//   properties: {
//     serverFarmId: appServicePlan.id
//     siteConfig: {
//       linuxFxVersion: linuxFxVersion
//     }
//     httpsOnly: httpsOnly
//   }
//   tags: {
//     environment: environment
//   }
// }

// // Outputs
// //output appServiceUrl string = 'https://${appService.defaultHostName}'
// output planId string = appServicePlan.id

param location string = resourceGroup().location
param appServicePlanName string = 'myAppServicePlan'
param skuName string = 'F1'
param skuTier string = 'Free'
param capacity int = 2

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: skuTier
    capacity: capacity
  }
  properties: {
    reserved: false  // Set to true for Linux-based hosting
  }
}
output appServicePlanId string = appServicePlan.id


