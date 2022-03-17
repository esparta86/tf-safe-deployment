Guia de instalacion rapida de Jenkins usando HELM3

Asegurate de tener instalado
- helm3 (Sobre windows que fue mi caso, instalalo usando chocolatey, un package manaer para windows )
  choco install kubernetes-helm



Dentro del directorio tf-safe-deployment/helm/jenkins


1. helm install jenkins -n jenkins -f values.yaml $chart  --debug --dry-run

2. Una vez instalado el Jenkins.
   Acceder al container jenkins en el pod de jenkins-0 con el siguiente comando.
    kubectl exec -it jenkins-0 -n jenkins -- bash

   Una vez dentro, ejecutar, para imprimir el password del usuario admin.
   /bin/cat /run/secrets/chart-admin-password && echo


3. Realizar un port forward para tener acceso al jenkins web

 kubectl --namespace jenkins port-forward svc/jenkins 8080:8080