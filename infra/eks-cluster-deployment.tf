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

#  This policy let kubernetes to manage resources on your behalf
# some tasks permited 
# autoscaling read and update the configuration
# ec2 work with volumens and network resources that are associated to amazon EC2 nodes
# elasticloadbalancing let k8s works with ELB and add nodes to them as targets.
# iam let k8s control plane can dynamically provision ELB requested by K8S services
resource "aws_iam_role_policy_attachment" "eks-amazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-role.name
}




# Retrieving all subnets with tag eks=deployment
data "aws_subnets" "subnetsids" {
  depends_on = [
    aws_vpc.main_vpc, aws_subnet.eks_private_subnet, aws_subnet.eks_public_subnet
  ]
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main_vpc.id]
  }

  tags = {
    "eks" = "deployment"
  }
}


#Provisioning the EKS cluster deployment
resource "aws_eks_cluster" "eks-deployment" {

  depends_on = [
    aws_vpc.main_vpc, aws_subnet.eks_private_subnet, aws_subnet.eks_public_subnet, aws_iam_role_policy_attachment.eks-amazonEKSClusterPolicy
  ]

  name    = var.cluster_deployment_name
  version = var.version_eks_deployment


  role_arn = aws_iam_role.eks-role.arn
  vpc_config {
    subnet_ids = data.aws_subnets.subnetsids.ids
  }


  timeouts {
    create = "40m"
    delete = "1h"
  }


}


