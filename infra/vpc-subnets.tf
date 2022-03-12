
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



# resource "aws_subnet" "eks-private-us-east-1a" {
#   vpc_id            = aws_vpc.main_vpc.id
#   cidr_block        = "10.0.0.0/19"
#   availability_zone = "us-east-1a"


#   tags = merge(var.default_tags, {
#     "Name"                            = "eks-private-us-east-1a"
#     "kubernetes.io/role/internal-elb" = "1"
#     "kubernetes.io/cluster/demo"      = "owned"
#   })
# }

# resource "aws_subnet" "eks-private-us-east-1b" {
#   vpc_id            = aws_vpc.main_vpc.id
#   cidr_block        = "10.0.32.0/19"
#   availability_zone = "us-east-1b"

#   tags = merge(var.default_tags, {
#     "Name"                            = "eks-private-us-east-1b"
#     "kubernetes.io/role/internal-elb" = "1"
#     "kubernetes.io/cluster/demo"      = "owned"
#   })
# }

# resource "aws_subnet" "eks-public-us-east-1a" {
#   vpc_id                  = aws_vpc.main_vpc.id
#   cidr_block              = "10.0.64.0/19"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true

#   tags = merge(var.default_tags, {
#     "Name"                       = "eks-public-us-east-1a"
#     "kubernetes.io/role/elb"     = "1"
#     "kubernetes.io/cluster/demo" = "owned"
#   })
# }

# resource "aws_subnet" "eks-public-us-east-1b" {
#   vpc_id                  = aws_vpc.main_vpc.id
#   cidr_block              = "10.0.96.0/19"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true

#   tags = merge(var.default_tags, {
#     "Name"                       = "public-us-east-1b"
#     "kubernetes.io/role/elb"     = "1"
#     "kubernetes.io/cluster/demo" = "owned"
#   })
# }
