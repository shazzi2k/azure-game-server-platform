# Azure Game Server Platform

## Overview

This project demonstrates the design and deployment of a secure Azure-hosted game server platform using Infrastructure as Code (IaC) with Bicep.

The platform deploys a Linux virtual machine for game hosting alongside supporting Azure services including networking, security, secrets management, monitoring, and logging.

The project was created to demonstrate practical Azure administration, security, monitoring, and automation skills relevant to cloud engineering and Azure administrator roles.

## Architecture

![Architecture  diagram]("azure-game-server-platform-master\images\imagesnew\architecture.png")

## Features

### Infrastructure as Code

* Modular Bicep deployment
* Parameter-driven configuration
* Repeatable deployments

### Networking

* Virtual Network (VNet)
* Dedicated subnet
* Network Security Group (NSG)
* Public IP assignment

### Compute

* Ubuntu Linux Virtual Machine
* Managed Identity enabled
* Automated deployment

### Security

* Azure Key Vault integration
* Secrets stored securely
* Key Vault RBAC permissions
* Managed Identity access to secrets

### Monitoring and Logging

* Azure Monitor Agent (AMA)
* Log Analytics Workspace
* Data Collection Rule (DCR)
* Syslog collection
* Centralised monitoring

## Azure Resources Deployed

* Virtual Network
* Subnet
* Network Security Group
* Public IP Address
* Ubuntu Virtual Machine
* Managed Identity
* Azure Key Vault
* Log Analytics Workspace
* Azure Monitor Agent
* Data Collection Rule
* Data Collection Rule Association

## Deployment Screenshots

### Resource Group Overview

![RG overview]("azure-game-server-platform-master\images\imagesnew\rgoverview.png")

### Key Vault RBAC Assignment

![KV RBAC]("azure-game-server-platform-master\images\imagesnew\managedID+rbac.png")

### Azure Monitor Agent Installation

![AMA]("azure-game-server-platform-master\images\imagesnew\azmonitoragent.png")

### Data Collection Rule Association

![DCR]("azure-game-server-platform-master\images\imagesnew\dcrassociation.png")

### Log Analytics Syslog Collection

![LAW results]("azure-game-server-platform-master\images\imagesnew\logqueryresults.png")

### Infrusture as code - Bicep

![VSS Bicep]("azure-game-server-platform-master\images\imagesnew\vssbicep.png")

## Repository Structure

```text
bicep/
├── Deploymain.bicep
├── modules/
│   ├── vm.bicep
│   ├── vnet.bicep
│   ├── nsg.bicep
│   ├── keyvault.bicep
│   ├── DCR.bicep
│   └── loganalytics.bicep
└── params/
```

## Skills Demonstrated

* Azure Infrastructure as Code (Bicep)
* Azure Virtual Machines
* Virtual Networking
* Network Security Groups
* Azure Key Vault
* Managed Identities
* Azure Monitor
* Log Analytics
* Data Collection Rules
* Azure RBAC
* Monitoring and Observability

## Future Enhancements

### Web Management Dashboard

Develop a web-based dashboard to:

* View server status
* Display monitoring metrics
* View logs and alerts
* Manage hosted game servers

### Discord Bot Integration

Develop a Discord bot and API integration to:

* Query server status
* Display player counts
* Start and stop services
* Receive monitoring alerts

### Advanced Monitoring

* Performance counters
* Custom log ingestion
* Azure alerts and action groups


