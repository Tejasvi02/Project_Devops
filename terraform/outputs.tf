output "cluster_name" {
  value = module.eks.cluster["name"]
}

output "eks_endpoint" {
  value = module.eks.cluster["endpoint"]
}

output "certificate_authority" {
  value = module.eks.cluster["certificate_authority"]
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}
