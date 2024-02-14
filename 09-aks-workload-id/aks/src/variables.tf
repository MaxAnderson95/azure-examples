variable "region" {
  description = "The Azure region in which resources will be deployed."
  type        = string
}

variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use for the AKS cluster."
  type        = string
}

variable "vnet_cidr" {
  description = "The CIDR block for the virtual network."
  type        = string
}

variable "pod_cidr" {
  description = "The CIDR block for the Kubernetes pods."
  type        = string
}

variable "service_cidr" {
  description = "The CIDR block for the Kubernetes services."
  type        = string
}

variable "admin_group" {
  description = "ID of the Azure AD group that will have admin access to the AKS cluster."
  type        = string
}
