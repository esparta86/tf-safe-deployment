

variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "default"
}


# this variable has default tags

variable "default_tags" {
  default = {
    cloudprovider = "aws"
    owner         = "devops-team"
    Terraform     = "true"
    Environment   = "Development"
  }
  description = "Default tags name to tag in resources"
  type        = map(string)
}

variable "cluster_deployment_name" {
  default     = "eks_deployment01"
  description = "Cluster name"
  type        = string
}


variable "version_eks" {
  default     = "1.20"
  description = "version cluster"
  type        = string
}