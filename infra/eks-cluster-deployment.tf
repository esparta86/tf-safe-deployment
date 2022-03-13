# Retrieving all subnets with tag eks=development
data "aws_subnets" "subnets_development_ids" {
  
  depends_on = [
    aws_vpc.main_vpc, aws_subnet.eks_private_subnet, aws_subnet.eks_public_subnet,aws_subnet.eks_private_subnet_development,aws_subnet.eks_public_subnet_development
  ]

  filter {
    name = "vpc-id"
    values = [aws_vpc.main_vpc.id]
  }

  tags = {
    "eks" = "development"
  }
}



#  Provisioning the EKS cluster
resource "aws_eks_cluster" "eks_development" {
  depends_on = [
    aws_iam_role_policy_attachment.eks-amazonEKSClusterPolicy, aws_vpc.main_vpc, aws_subnet.eks_private_subnet, aws_subnet.eks_public_subnet,aws_subnet.eks_private_subnet_development,aws_subnet.eks_public_subnet_development
  ]
  name    = var.cluster_development_name
  version = var.version_eks_deployment


  role_arn = aws_iam_role.eks-role.arn
  vpc_config {
    subnet_ids = data.aws_subnets.subnets_development_ids.ids
  }


  timeouts {
    create = "40m"
    delete = "1h"
  }


}


