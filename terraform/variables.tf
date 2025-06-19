variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.25"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "public_subnet_azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}