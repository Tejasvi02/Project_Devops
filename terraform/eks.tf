module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = aws_vpc.eks_vpc.id
  subnet_ids = aws_subnet.public_subnets[*].id

  enable_irsa = true

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  eks_managed_node_groups = {
    default_node_group = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
#      key_name       = var.key_name
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
