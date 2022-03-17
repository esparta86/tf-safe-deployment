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


## Descripcion de los archivos de Terraform para el aprovisionamiento de la infrastructura en AWS

El directorio **infra** contiene los archivos necesarios para realizar el provisionamiento de la infrastructura.

Archivos:

* `provider.tf`  Contiene la seleccion del cloud provider elegido **AWS** , Donde definimos la version, region y profile del mismo.
* `vpc-subnets.tf` Contiene la declaracion de los recursos como **VPC**,**Zonas Disponibles**, **subnets**.
* `variables.tf` Contiene la declaracion de aquellos valores que requerimos que no sean estaticos y nos permitan hacer actualizaciones de una forma mas rapida y confiable.
* `nat.tf` Como estamos provisionando redes privadas para nuestro EKS. Es necesario **NAT** para asegurarnos que el EKS cluster podra bajar recursos de **Internet**.
* `igw.tf` Contiene la declaracion del recurso **Internet Gateway** Componente asociado a la VPC para que nuestras ***subnets** tengan comunicacion con internet y a la vez ejecute tareas de **NAT** para instancias.
* `routes.tf` Contiene las rutas establecidas para las redes publicas y privadas (internet gateway para Publica y NAT para privadas), Tambien posee las asociaciones entre las rutas y las subnets.
* `eks-cluster.tf` Contiene la definicion del **IAM** role  y el provisionamiento del cluster de **deployment**.
* `eks-cluster-deployment.tf` Contiene la definicion del **IAM** role  y el provisionamiento del cluster de **development**.
* `nodes.tf` Contiene la definicion del iam y policies para el manejo del **eks** cluster, hace uso de un data source para seleccionar todas las redes solo para el **EKS cluster** de **deployment**.
* `nodes-development.tf` Contiene la definicion del iam y policies para el manejo del **eks** cluster, hace uso de un data source para seleccionar todas las redes solo para el **EKS cluster** de **development**.
* `iam-oidc.tf` Contiene la definicion de un **Identity Provider** para los **EKS** de **development** y **deployment** ,esto nos ayudara a asociar una **IAM role** con **Services accounts** del **EKS**.



## Diagrama de la solucion




## Pasos para el aprovisionamiento

Se requiere:

* Instalacion de AWS-CLI en su maquina 
* Configuracion usando : aws configure  y proviendo el KEY ID y PASS
* Se requiere tener instalado terraform

1. Usando la terminal, vaya al directorio  tf-safe-deployment/infra
2. Ejecute el comando de inicializacion
    ```sh
     $ terraform init
    ```
3. Ejecute el commando de planeacion
    ```sh
     $ terraform plan
    ```
3. Ejecute el commando de provisionamiento
    ```sh
     $ terraform apply
    ```





## Accediendo al cluster de deployment

aws eks --region us-east-1 update-kubeconfig --name eks_deployment01

Servicios desplegados en este cluster:

- Jenkins como despliegue statefulset y con persistence volumen claim con el gp2 StorageClass
- 



## Accediendo al cluster de development

aws eks --region us-east-1 update-kubeconfig --name eks_development01
