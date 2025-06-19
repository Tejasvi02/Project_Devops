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

  map_roles    = []
  map_users    = []
  map_accounts = []

  manage_aws_auth = false
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}