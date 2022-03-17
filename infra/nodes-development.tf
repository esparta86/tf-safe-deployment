

# We should filter only private networks
data "aws_subnets" "private_subnets_development_ids" {
  depends_on = [
    aws_vpc.main_vpc, aws_subnet.eks_private_subnet_development, aws_subnet.eks_public_subnet_development
  ]

  filter {
    name   = "vpc-id"
    values = [aws_vpc.main_vpc.id]
  }

  tags = {
    "tier" = "Private"
    "eks"  = "development"
  }
}



resource "aws_eks_node_group" "private-nodes-development" {

  depends_on = [
    aws_vpc.main_vpc, aws_subnet.eks_private_subnet_development, aws_subnet.eks_public_subnet_development, aws_eks_cluster.eks_development
  ]

  cluster_name = aws_eks_cluster.eks_development.name

  node_group_name = "private-nodes-eks-development"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = data.aws_subnets.private_subnets_development_ids.ids

  capacity_type = "ON_DEMAND"

  instance_types = ["t2.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }


  labels = {
    "role" = "development"
  }



}


