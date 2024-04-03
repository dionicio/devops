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

-- setup an ingress controller  in the cluster development    
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace   

--- add an ingress in the cluster developmente  
kubectl apply -f 5-ingress.yaml  

-- create a service account in the cluster development    
  - kubectl apply -f 4-service-account.yaml  
  - get the token, it will be setup in jenkins  
    kubectl describe secrets  jenkins-deployer-token     

-- configure jenkins --   
steps  
  add sonar server and scanner   
  configure development kubernetes
  configure git   
  configure docker hub    
  create jenkins pipeline located in folder "jenkins" file Jenkinfile   
  run jenkins job   

--- setup an autoscaler in deployment cluster  
   -- 1- check and copy the terraform output for example   
         "arn:aws:iam::197687902162:role/eks-cluster-autoscaler"  
      Outputs:  
      eks_cluster_autoscaler_arn = "arn:aws:iam::197687902162:role/eks-cluster-autoscaler"  

   -- 2- paste in the file 1-cluster-autoscaler.yaml  line 11  
    eks.amazonaws.com/role-arn: arn:aws:iam::197687902162:role/eks-cluster-autoscaler    

   -- 3- deploy autoscaler  
      kubectl apply -f 1-cluster-autoscaler.yaml      
