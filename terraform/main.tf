# EKS Cluster Configuration

# VPC Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  name    = "eks-vpc"
  cidr    = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

# EKS Module
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets
  vpc_id         = module.vpc.vpc_id

  node_groups = {
    on_demand = {
      desired_size = var.on_demand_desired_size
      max_size     = var.on_demand_max_size
      min_size     = var.on_demand_min_size
      instance_type = var.on_demand_instance_type
    }
    spot = {
      desired_size = var.spot_desired_size
      max_size     = var.spot_max_size
      min_size     = var.spot_min_size
      instance_type = var.spot_instance_type
    }
  }

  iam_roles = [
    { 
      name = "cluster-autoscaler"
      permissions_boundary = "arn:aws:iam::aws:policy/autoScaling:Policy"
      description = "Cluster Autoscaler IAM Role"
    },
    { 
      name = "ebs-csi-driver"
      permissions_boundary = "arn:aws:iam::aws:policy/EBSCSI"
      description = "EBS CSI Driver IAM Role"
    }
  ]

  tags = {
    Environment = var.environment
  }
}

# EKS Addons
resource "aws_eks_addon" "coredns" {
  cluster_name = module.eks.cluster_id
  addon_name   = "coredns"
  service_account_role_arn = module.eks.cluster_iam_roles[0].arn
  vpc_id = module.vpc.vpc_id
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = module.eks.cluster_id
  addon_name   = "kube-proxy"
  service_account_role_arn = module.eks.cluster_iam_roles[1].arn
  vpc_id = module.vpc.vpc_id
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = module.eks.cluster_id
  addon_name   = "ebs-csi-driver"
  service_account_role_arn = module.eks.cluster_iam_roles[1].arn
  vpc_id = module.vpc.vpc_id
}
