

resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}


resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}



resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}



# We should filter only private networks
data "aws_subnets" "private_subnets_ids" {
    depends_on = [
    aws_vpc.main_vpc
  ]

  filter {
    name = "vpc-id"
    values = [aws_vpc.main_vpc.id]
  }

  tags = {
    "tier" = "Private"
  }
}



resource "aws_eks_node_group" "private-nodes" {
  cluster_name = aws_eks_cluster.eks-deployment.name

  node_group_name = "private-nodes-eks-deployment"
  node_role_arn   = aws_iam_role.nodes.arn

  # subnet_ids = [
  #   aws_subnet.eks-private-us-east-1a.id,
  #   aws_subnet.eks-private-us-east-1b.id
  # ]

  subnet_ids = data.aws_subnets.private_subnets_ids.ids

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
    "role" = "deployment"
  }



}


