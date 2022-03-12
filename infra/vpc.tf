
# This object is going to return all zones availables
# in a specif region, just I am going to work with 2 zones availables
data "aws_availability_zones" "available" {
  filter {
    name   = "zone-name"
    values = ["us-east-1a", "us-east-1c"]
  }
}

locals {
  cluster_name = "cluster-eks"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name                 = "k8s-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = merge(var.default_tags, {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "vpc-name"                                    = "k8s-vpc"
  })

  public_subnet_tags = merge(var.default_tags, {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  })

  private_subnet_tags = merge(var.default_tags, {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  })

}

