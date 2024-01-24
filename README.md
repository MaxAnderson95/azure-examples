# Azure Networking Examples

The repository contains examples of some Azure networking deployments, starting with a simple vnet, to (eventually) a multi-hub Azure Virtual WAN deployment.

The examples are written in Terraform for ease of creation and tear-down. Each example has its own README and a diagram explaining what is deployed.

## Examples

* [Single VNet](/00-single-vnet/)
* [Single VNet with NAT Gateway](/01-single-vnet-natgw/)
* [Single VNet with Azure Firewall](/02-single-vnet-azfw/)
* [Hub and two spoke VNets with Azure Firewall](/03-hub-and-spoke-vnet-azfw/)
* [Virtual WAN with a single secure hub and two spoke VNets w/ Azure Firewall](/04-vwan-single-secure-hub/)
