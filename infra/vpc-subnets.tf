
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = merge(var.default_tags,{
    Name = "main"
  })
}

resource "aws_subnet" "eks-private-us-east-1a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "us-east-1a"

  tags = merge(var.default_tags,{
    "Name"                            = "eks-private-us-east-1a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  })
}

resource "aws_subnet" "eks-private-us-east-1b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-east-1b"

  tags = merge(var.default_tags,{
    "Name"                            = "eks-private-us-east-1b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  })
}

resource "aws_subnet" "eks-public-us-east-1a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = merge(var.default_tags,{
    "Name"                       = "eks-public-us-east-1a"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  })
}

resource "aws_subnet" "eks-public-us-east-1b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = merge(var.default_tags,{
    "Name"                       = "public-us-east-1b"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  })
}
