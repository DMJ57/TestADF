param location string = resourceGroup().location
param keyVaultName string = 'komatsuKeyvault33'
param skuName string = 'standard' // Supported values: 'standard' or 'premium'
param tenantId string = subscription().tenantId // Tenant ID for the Key Vault

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: skuName
    }
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: '<YOUR-OBJECT-ID>' // Replace with your Azure AD Object ID
        permissions: {
          keys: [
            'get'
            'list'
            'create'
            'delete'
            'backup'
            'restore'
            'recover'
            'purge'
          ]
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
          certificates: [
            'get'
            'list'
            'create'
            'delete'
            'managecontacts'
            'manageissuers'
            'recover'
            'purge'
          ]
        }
      }
    ]
  }
}

output keyVaultId string = keyVault.id
