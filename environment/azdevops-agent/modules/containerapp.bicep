// general Azure Container App settings
param location string
param name string
param containerAppEnvironmentId string

// Container Image ref
param containerImage string

// AzDevOps pool metadata
@secure()
param azpToken string
param azpUrl string
param azpPool string
param azpPoolId string

resource containerApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: 'capp-${name}'
  location: location
  properties: {
    configuration: {
      ingress: {
        allowInsecure: true
        external: true
        targetPort: 8000
        transport: 'auto'
      }
      secrets: [
        {
          name: 'azptoken'
          value: azpToken
        }
        {
          name: 'orgurl'
          value: azpUrl
        }
      ]
    }
    managedEnvironmentId: containerAppEnvironmentId
    template: {
      containers: [
        {
          env: [
            {
              name: 'AZP_TOKEN'
              secretRef: 'azptoken'
            }
            {
              name: 'AZP_POOL'
              value: azpPool
            }
            {
              name: 'AZP_URL'
              secretRef: 'orgurl'
            }
          ]
          image: containerImage
          name: 'azdevops-agent'
          probes: [
            {
              type: 'Readiness'
              httpGet: {
                port: 8000
                path: '/test'
              }
            }
            {
              type: 'Startup'
              initialDelaySeconds: 20
              httpGet: {
                port: 8000
                path: '/test'
              }
            }
          ]
        }
      ]
      scale: {
        maxReplicas: 3
        minReplicas: 1
        rules: [
          {
            name: 'azure-pipeline-scaler'
            custom: {
              metadata: {
                poolID: azpPoolId
                poolName: azpPool
              }
              auth: [
                {
                  secretRef: 'azptoken'
                  triggerParameter: 'personalAccessToken'
                }
                {
                  secretRef: 'orgurl'
                  triggerParameter: 'organizationURL'
                }
              ]
              type: 'azure-pipelines'
            }
          }
        ]
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
