# Deploying Azure DevOps Agents on Azure Container Apps

## Introduction

Running Devops Agents on Azure Container Apps

## Configuration

1. Create an Azure DevOps Agent Pool:
   - Log in to your Azure DevOps account and go to your project
   - Go to your project settings
   - Go to the "Agent Pools" section in the left-side menu
   - Click on the "Add Pool" button
   - Select "new", type as "Self-hosted" and give the agent pool a name, for example, "azure-container-apps-pool".
   - Click on "Create"
   - Open the Pool and get the PoolId from the URL, you will need it next.

2. Create an Azure DevOps Library:
   - Log in to your Azure DevOps account and go to your project
   - Go to the "Library" section in the left-side menu
   - Click on the "+ Variable Group" button
   - Give the library a name, for example, "azdevops-agent-aca"
   - Fill in the following variables:
     - `azpToken` (pat token - make sure you make this variable a secret)
     - `azpUrl` (url to your az devops project, NO TAILING / char it should look something like "https://dev.azure.com/myorg")
     - `azpPool` (pool name given when creating the az devops agent pool)
     - `azpPoolId` (pool id extracted earlier,pool ID should be read from organization level not from project level, you can get it from the url easily)

3. Set pipeline variables:
    - Fork this repo
    - Edit the file `pipelines\azdevops-agent.yml` and set the right values for:
     - `group` (must match the new library name)
     - `azureServiceConnection`
     - `resourceGroupName`
     - `location`

## (Optional) Sample Pipeline Deployment

Follow the steps below to create a dummy pipeline based on the file `pipelines\sample-pipeline.yml`
This creates a starter pipeline that simply echo messages. You can use it to queue as many jobs you like and Kubernetes Events Driven Auto-scaling in action.

1. Edit the sample pipeline, adjust the pool name
2. Run and enjoy :D 

## Outcome

Auto scaling azure devops agents.
If you run the pipeline in your own account, pay attention the maximum parallel jobs for private in Azure Devops is 1 by default.

## Docker Container

I created my own Docker Container to bootstrap the agent based on Microsoft doc: [Running self-hosted agents in Docker](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops).

docker.io/posannorbert/agentwithprobe

Probes replies to HTTP GET /test on port 8000

## Known issues

During biceps deployment somehow the probes and up as TCP requests.

## Limitations

- Azure Container Apps currently supports only Linux containers.
- Azure Container Apps Environments require a dedicated subnet with a CIDR range /23 or larger.
- Only non root containers

## References

- [Inspired by this article](https://github.com/lopezleandro03/azdevops-agents-on-container-apps)

