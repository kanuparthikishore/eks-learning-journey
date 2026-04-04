# EKS Setup Guide

This guide provides comprehensive, step-by-step instructions for setting up an Amazon EKS (Elastic Kubernetes Service) cluster using Terraform, configuring kubectl, and deploying an application.

## Prerequisites
- AWS Account
- AWS CLI installed and configured
- Terraform installed
- kubectl installed

## Step 1: Configure AWS CLI  
Make sure AWS CLI is configured with your credentials:
```bash
aws configure
```

## Step 2: Create a Terraform Configuration
1. Create a new directory for your Terraform files:
   ```bash
   mkdir eks-terraform
   cd eks-terraform
   ```

2. Create a file named `main.tf` and add the following code:
   ```hcl
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 3.0"
       }
     }

     required_version = ">= 0.12"
   }

   provider "aws" {
     region = "us-west-2"
   }

   resource "aws_eks_cluster" "main" {
     name     = "my-eks-cluster"
     role_arn = aws_iam_role.eks_cluster_role.arn

     vpc_config {
       subnet_ids = [aws_subnet.public_subnet.id]
     }
   }

   # Add other AWS resources like VPC, Subnets, Node Groups, etc.
   ```

3. Add necessary IAM roles and policies for EKS service.

## Step 3: Initialize Terraform
Run the following command to initialize Terraform:
```bash
tf init
```

## Step 4: Plan the Deployment
To preview the changes Terraform will make to your environment:
```bash
tf plan
```

## Step 5: Apply the Configuration
Deploy your EKS cluster:
```bash
tf apply
```

## Step 6: Configure kubectl
1. Install the `aws-iam-authenticator` if you haven't already:
   ```bash
   brew install aws-iam-authenticator
   ```

2. Update the kubeconfig file:
```bash
aws eks --region us-west-2 update-kubeconfig --name my-eks-cluster
```

3. Verify that kubectl is configured correctly:
   ```bash
   kubectl get svc
   ```

## Step 7: Deploy an Application
1. Create a simple deployment (e.g., NGINX):
   ```bash
   kubectl create deployment nginx --image=nginx
   ```

2. Expose the deployment:
   ```bash
   kubectl expose deployment nginx --port=80 --type=LoadBalancer
   ```

3. Retrieve the external IP:
   ```bash
   kubectl get services
   ```

Now your application should be accessible via the external IP.

## Conclusion
You have successfully set up an EKS cluster using Terraform and deployed an application. Further customization and scaling can be done based on your needs.  
For detailed documentation, refer to the [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html).
