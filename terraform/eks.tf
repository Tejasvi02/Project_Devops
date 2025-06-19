data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 16.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  worker_groups_launch_template = [
    {
      name                 = "default"
      instance_type        = "t3.medium"
      asg_desired_capacity = 1
      asg_min_size         = 1
      asg_max_size         = 2
    }
  ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}