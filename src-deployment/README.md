


- Generando una nueva imagen y agregando el tag repositorio:v#

docker build -t esparta2018/hello-bank:v# .

- Tageando una docker image local

docker tag lisandro.rafaelano/helloworld:v2 esparta2018/hello-bank:v1


- Push a un container registry en docker hub.
  Autentiquese con su usuario en dockerHub

  docker login -u esparta2018

  docker push esparta2018/hello-bank:v1



  - Despliegue manual en development_eks
    
    Usando una terminal, ejecute
    $ cd tf-safe-deployment/src-deployment/k8s/deployment

    $ kubectl apply -f deploy.yaml -n development-a

    Verifique el estado de los PODs ejecutando

    $ kubectl get pods -n development-a

    La salida deberia ser similar

    NAME                                           READY   STATUS    RESTARTS   AGE
global-hello-world-frontend-6547c57bc8-gn6tk   1/1     Running   0          10m
global-hello-world-frontend-6547c57bc8-k2ndx   1/1     Running   0          10m


- Despliegue del servicio

  
- Verificacion de que el service nodeports en los endpoints, tenga las dos ips de los pods creados.

 $ kubectl describe svc global-helloworldfrontend-nodeport-svc -n development-a


- Verificacion, usando port-forward del servicio desplegado

 kubectl port-forward service/global-helloworldfrontend-nodeport-svc 8082:8080 -n development-a

 Verificar localmente, usando el navegador y abriendo una pestania

 http://localhost:8082/

 