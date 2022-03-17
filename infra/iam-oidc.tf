# --------------------------------------------- EKS deployment

data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks-deployment.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]

  url = aws_eks_cluster.eks-deployment.identity[0].oidc[0].issuer
}



# ---------------------------------------------  EKS Development ---------------------------------------------


data "tls_certificate" "eks_development" {
  url = aws_eks_cluster.eks_development.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_development" {
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.tls_certificate.eks_development.certificates[0].sha1_fingerprint]

  url = aws_eks_cluster.eks_development.identity[0].oidc[0].issuer
}