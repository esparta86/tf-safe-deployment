# tf-safe-deployment

Repositorio que agrupa las herramientas de provisionamiento de infrastructura, Docker y despliegue continuo de cambios
en un hello world app, realizada en Spring Boot con Java 16

* helm\jenkins contiene el archivo **values.yaml** , con este archivo realizamos una instalacion de Jenkins usando helm

* infra directorio que tiene los archivos **.tf** que en conjunto con **Terraform** Definimos los recursos necesarios 
  para el provisionamiento de la infrastructura

* src-deployment directorio que contiene
  - helloworld16 Codigo realizado con Spring boot y timeleaf para el despliegue de una applicacion web usando **Java16**
  - Jenkinsfile archivo que contiene los pasos necesarios de un **CICD**
  - k8s Directorio que contiene los manifest para un objeto deploymento y servicio en EKS
  - Dockerfile Contiene la sintaxis necesaria para construir una imagen de docker usando **maven:3.8.3-openjdk-16** y **openjdk:16-jdk-buster**


<p align="center">
  <img src="./img/helloworldapp.png" alt="Simple hello world from EKS" width="738">
</p>

- Instale  AWS CLI en Windows usando
  choco install awscli

- Genere  un secret key ID y ejecute el comando
  $ aws configure


## Provisionando la infrastructura en AWS

1. 




## Accediendo al cluster de deployment

aws eks --region us-east-1 update-kubeconfig --name eks_deployment01

Servicios desplegados en este cluster:

- Jenkins como despliegue statefulset y con persistence volumen claim con el gp2 StorageClass
- 



## Accediendo al cluster de development

aws eks --region us-east-1 update-kubeconfig --name eks_development01
