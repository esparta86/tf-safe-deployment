
module "eks_development" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = var.cluster_deployment_name
  cluster_version = var.version_eks
  subnets         = module.vpc.private_subnets

  cluster_create_timeout = "20m"

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  #We are going to use this instead node_groups
  # worker_groups are more custom and are self managed nodes
  worker_groups = [
    {
      name                          = "worker-group-a"
      instance_type                 = "t2.medium"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.wg-a.id]
      kubelet_extra_args            = "--node-labels=node_group=regular-performance-worker"


    }

  ]

  tags = merge(var.default_tags, {
    performance = "regular"
  })




}


data "aws_eks_cluster" "cluster" {
    name = module.eks_development.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_development.cluster_id
}

