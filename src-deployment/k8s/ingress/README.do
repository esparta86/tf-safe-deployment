

1. obtener OIDC URL

aws eks describe-cluster --name eks_development01 --query "cluster.identity.oidc.issuer" --output text

2 editar archivo load-balancer-role-trust-policy.json

3. Ejecutar

aws iam create-role \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --assume-role-policy-document file://"load-balancer-role-trust-policy.json"


aws iam attach-role-policy \
  --policy-arn arn:aws:iam::734237051973:policy/AWSLoadBalancerControllerIAMPolicy \
  --role-name AmazonEKSLoadBalancerControllerRole



eksctl create iamserviceaccount \
--cluster=eks_development01 \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::734237051973:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--approve