
resource "aws_vpc" "main_vpc" {
  cidr_block = var.development_vpc_cidr

  tags = merge(var.default_tags, {
    Name = "main"
  })
}



data "aws_availability_zones" "available" {
  filter {
    name   = "zone-name"
    values = ["us-east-1a", "us-east-1b", "us-east-1c"]
  }
}



# cidrsubnet("10.0.0.0/16",8,1)
# "10.0.1.0/24"
# > cidrsubnet("10.0.0.0/16",8,2)
# "10.0.2.0/24"
resource "aws_subnet" "eks_private_subnet" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = cidrsubnet(var.development_vpc_cidr, 8, count.index + 1)

  tags = merge(var.default_tags, {
    "Name"                            = "eks-private-subnet-${count.index}-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
    "tier" = "Private"
    "eks" = "deployment"
  })

}



resource "aws_subnet" "eks_public_subnet" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  # We can not use just cidrsubnet(var.development_vpc_cidr, 8, count.index + 1) because it will produce an overlapping 
  # the CIDR Block have to start in the next jump from the last CIDR used by the eks_private subnets
  cidr_block              = cidrsubnet(var.development_vpc_cidr, 8,length(data.aws_availability_zones.available.names) + count.index + 1)

  tags = merge(var.default_tags, {
    "Name"                            = "eks-public-subnet-${count.index}-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
    "tier" = "Public"
    "eks" = "deployment"
  })

}

# ----------------- VPC SUBNETS FOR SECOND CLUSTER -------------------------



# Calculate how many subnets related to first EKS

data "aws_subnets" "list_subnets_deployment_eks_ids" {
    depends_on = [
    aws_vpc.main_vpc, aws_subnet.eks_private_subnet, aws_subnet.eks_public_subnet
  ]

  filter {
    name = "vpc-id"
    values = [aws_vpc.main_vpc.id]
  }

  tags = {
    "eks" = "deployment"
  }
}


resource "aws_subnet" "eks_private_subnet_development" {
  depends_on = [
    aws_vpc.main_vpc, aws_subnet.eks_private_subnet, aws_subnet.eks_public_subnet
  ]
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = cidrsubnet(var.development_vpc_cidr, 8,length(data.aws_subnets.list_subnets_deployment_eks_ids.ids) + count.index + 1)

  tags = merge(var.default_tags, {
    "Name"                            = "eks_private_subnet_development-${count.index}-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
    "tier" = "Private"
    "eks" = "development"
  })

}



data "aws_subnets" "all_list_subnets_deployment_eks_ids" {
    depends_on = [
    aws_vpc.main_vpc, aws_subnet.eks_private_subnet, aws_subnet.eks_public_subnet,aws_subnet.eks_private_subnet_development
  ]

  filter {
    name = "vpc-id"
    values = [aws_vpc.main_vpc.id]
  }

  filter {
    name = "tag:eks"
    values = ["deployment", "development" ]
  }
  
}


# sticky  10
# Because We need to improve how to filter all subnets


resource "aws_subnet" "eks_public_subnet_development" {
  depends_on = [
    aws_vpc.main_vpc, aws_subnet.eks_private_subnet, aws_subnet.eks_public_subnet,aws_subnet.eks_private_subnet_development
  ]
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = cidrsubnet(var.development_vpc_cidr, 8,  count.index + 10)

  tags = merge(var.default_tags, {
    "Name"                            = "eks_public_subnet_development-${count.index}-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
    "tier" = "Public"
    "eks" = "development"
  })

}
