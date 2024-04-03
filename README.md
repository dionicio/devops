This a CI/CD process applied to a spring boot app and built with maven, for integration was used jenkins 
and deployed in aws eks.

tools list

    helm 
    terraform
    jenkins
    sonarqube
    docker 
    kubernates
    aws services
    aws cli
    git

steps:

--- connect to aws
aws configure

---- create aws resources
cd aws    
terraform init  
terraform validate  
terraform apply 

-- connect to eks --  

aws eks update-kubeconfig --region us-east-1 --name deployment  

---- configure volume --    
kubect apply -f volume k8s/1-volumen.yaml   

----- add jenkins --- 

helm repo add jenkins https://charts.jenkins.io   
helm repo update    
helm upgrade --install -f jenkins/values.yaml myjenkins jenkins/jenkins   

----- add sonarqube ---   
kubectl apply -f 2-sonar-postgresql.yaml    
kubectl apply -f 3-sonarqube.yaml   

--  ingress controller    
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace   


-- configure jenkins --   
steps  
  add sonar server and scanner   
  configure development kubernetes   
  configure git   
  configure docker hub    
  create jenkins pipeline located in folder "jenkins" file Jenkinfile   
  run jenkins job   
