# Terraform Infra

## Infra Archtecture

<p align="center">  
	<img src=./docs/Arquitetura.png
	  width="350"
	/>
</p>

## Infra Info
- VPC
  - 1 Vpc *(us-east-1)*
- Subnets
  - 3 publicas *(us-east-1a us-east-1b us-east-1c)*
  - 3 privadas *(us-east-1a us-east-1b us-east-1c)*
  - 3 intra (Do EKS Control Plane) *(us-east-1a us-east-1b us-east-1c)*
- Route Tables
  - 1 Publica 
  - 1 Privada
  - 1 Intra
- Nat
  - 1 NatGateway
- IGW
  - 1 Internet Gateway
- EKS  
  - Mult Az em 3 Zonas de Disponibilidade
- AutoScaller
  - Karpenter
- ECR
  - 1 Registry Pras imagens docker
- Resoucer
  - Metrics Server
  - Kube State Metrics
  - Load Balancer Controller
    - Nginx


### Pre Requirements To Run This Pipeline.

- Create a S3 Bucket in AWS Console (Unique Global Name)
  - Enable Versioning Bucket
* Change the *Bucket Name and DynamoDB Table Name* in backend.conf files `(./terraform/envs/dev | ./terraform/envs/prod)`
- Create a DynamoDB Table in AWS Console
  - Put In *Partition key* to *LockID* And Set *String* And *Crete Table*
- Create a Identity Provider (OIDC) in IAM Console and add ARN on github variables with Name: *AWS_ASSUME_ROLE_ARN*
  - How To Create a OIDC Github
    - https://aws.amazon.com/pt/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/


This Pipeline Runs With a Pull Request:
- Branches:
    - developer - Runs Developer Infra
    - main      - Runs Productions Infra

### Runs Localy

Get AWS Credentials And Runs:
```shell
aws configure  # And Paste de SECRET_KEY_ID and  SECRET_ACCESS_KEY and REGION

# After aws configure go to de Path /terraform and Runs: Config Backend S3
terraform init -backend-config=envs/dev/backend.tfvars

# Set Dev Worspace
terraform workspace new dev

# Runs Plan
terraform plan -out plan.out -var-file=envs/dev/terraform.tfvars

# Aplly Plan
terraform apply plan.out
```


### Login in Cluster EKS
```bash
  aws eks update-kubeconfig --name <CLUSTER_NAME>
```

## TroubleShooting

### If You Lost Permissions To Access Cluter Resources Before Pipeline Runs:
  - Go to the aws console > eks > *cluster_name*
  - Click on Access setion, and create *access entry*
    - Select your ARN user, Type Standard and Next
      - Policy Name Add Two Permissions:
        - AmazonEKSAdminPolicy
        - AmazonEKSClusterAdminPolicy
  - And try to accessa cluster resouces again
```shell
  aws eks update-kubeconfig --name <CLUSTER_NAME>
```  

### Get Metrics of Metrics Server
- After run *aws eks update-kubeconfig --name <CLUSTER_NAME>*
```shell
kubectl top nodes

NAME                          CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
ip-10-0-16-84.ec2.internal    88m          4%     1111Mi          33%       
ip-10-0-27-85.ec2.internal    62m          3%     640Mi           19%       
ip-10-0-34-238.ec2.internal   70m          3%     683Mi           20%   
```
Or, to See Pods Metrics All Namespaces
```shell
kubectl top pods -A

NAMESPACE            NAME                                                         CPU(cores)   MEMORY(bytes)   
ingress-nginx        external-ingress-ingress-nginx-controller-5cd948cb99-wkqd4   1m           37Mi            
kube-state-metrics   kube-state-metrics-675b764b4b-h62w8                          2m           12Mi            
kube-system          aws-load-balancer-controller-bc76b68f5-257s4                 1m           21Mi            
kube-system          aws-load-balancer-controller-bc76b68f5-8d76v                 2m           23Mi            
kube-system          aws-node-hkrkr                                               3m           60Mi            
kube-system          aws-node-jrcdj                                               6m           59Mi            
kube-system          aws-node-nhrmj                                               5m           59Mi            
kube-system          coredns-d69f548b6-d6fzf                                      2m           12Mi            
kube-system          coredns-d69f548b6-hhnl7                                      1m           12Mi            
kube-system          ebs-csi-controller-7b788b4657-vgztt                          3m           54Mi            
kube-system          ebs-csi-controller-7b788b4657-wmkss                          2m           50Mi            
kube-system          ebs-csi-node-69xj6                                           1m           20Mi            
kube-system          ebs-csi-node-n99wp                                           1m           20Mi            
kube-system          ebs-csi-node-xhj9s                                           1m           20Mi            
kube-system          efs-csi-controller-5f8586cd56-fjdmz                          2m           44Mi            
kube-system          efs-csi-controller-5f8586cd56-zjmwh                          2m           42Mi            
kube-system          efs-csi-node-ctb7c                                           3m           43Mi            
kube-system          efs-csi-node-mfmbc                                           3m           41Mi            
kube-system          efs-csi-node-qwk7x                                           4m           42Mi            
kube-system          eks-pod-identity-agent-47ffh                                 1m           5Mi             
kube-system          eks-pod-identity-agent-kxktv                                 1m           7Mi             
kube-system          eks-pod-identity-agent-t6wkk                                 1m           5Mi             
kube-system          karpenter-5dd856fb78-ndfxj                                   7m           187Mi           
kube-system          kube-proxy-7lgqf                                             1m           12Mi            
kube-system          kube-proxy-lrnbh                                             1m           12Mi            
kube-system          kube-proxy-xsdb8                                             1m           12Mi            
kube-system          metrics-server-7998667b79-v547h                              3m           19Mi
```