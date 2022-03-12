resource "aws_iam_role" "eks-role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "eks-amazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-role.name
}


data "aws_subnets" "subnetsids" {
  depends_on = [
    aws_vpc.main_vpc
  ]
  filter {
    name = "vpc-id"
    values = [aws_vpc.main_vpc.id]
  }

  tags = {
    "eks" = "deployment"
  }
}

#  Provisioning the EKS cluster
resource "aws_eks_cluster" "eks-deployment" {
  name    = var.cluster_deployment_name
  version = var.version_eks_deployment


  role_arn = aws_iam_role.eks-role.arn
  vpc_config {
    # subnet_ids = [
    #   aws_subnet.eks-private-us-east-1a.id,
    #   aws_subnet.eks-private-us-east-1b.id,
    #   aws_subnet.eks-public-us-east-1a.id,
    #   aws_subnet.eks-public-us-east-1b.id
    # ]

    subnet_ids = data.aws_subnets.subnetsids.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-amazonEKSClusterPolicy
  ]

  timeouts {
    create = "40m"
    delete = "1h"
  }


}


