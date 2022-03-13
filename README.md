# tf-safe-deployment


- Instale  AWS CLI en Windows usando
  choco install awscli

- Genere  un secret key ID y ejecute el comando
  $ aws configure




## Accediendo al cluster de deployment

aws eks --region us-east-1 update-kubeconfig --name eks_deployment01

Servicios desplegados en este cluster:

- Jenkins como despliegue statefulset y con persistence volumen claim con el gp2 StorageClass
- 



## Accediendo al cluster de development

aws eks --region us-east-1 update-kubeconfig --name eks_development01
