variable "vpc_name" {
  description = "Name of VPC"
  type        = string
}

variable "region" {
  description = "Name of region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Enable or disable NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Enable or disable NAT Gateway"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Enable or disable NAT Gateway"
  type        = bool
  default     = false
}


variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of Kubernetes to install the cluster"
  type        = string
}

variable "creator_admin_permissions" {
  description = "Role ARN to use for administrator created on the cluster"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Endpoint public endpoint public access enabled"
  type        = bool
  default     = true
}

variable "ami_type" {
  description = "The type of the AMI to use for the instances."
  type        = string
}

variable "instance_types" {
  description = "Worker instance types for worker nodes"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of nodes for the cluster."
  type        = number
}

variable "max_size" {
  description = "Maximum number of nodes for the cluster."
  type        = number
}

variable "desired_size" {
  description = "Desired number of nodes for the cluster."
  type        = number
}


# variable "enable_v1_permissions" {
#   description = "Enable "
#   type        = bool
#   default     = true
# }
#
# variable "enable_pod_identity" {
#   description = "Enable pod identity usage"
#   type        = bool
#   default     = true
# }
#
# variable "create_pod_identity_association" {
#   description = "Enable pod identity association usage"
#   type        = bool
#   default     = true
# }

variable "metrics_server_version" {
  description = "Version of the Metrics server Helm Chart"
  type        = string
}

variable "metrics_server_namespace" {
  description = "Namespace of the Metrics server Install Helm Chart"
  type        = string
  default     = "kube-system"
}
variable "kube_state_metrics_version" {
  description = "Version of the Metrics server Helm Chart"
  type        = string
}
variable "prometheus_stack_versions" {
  description = "Version of the Metrics server Helm Chart"
  type        = string
}

variable "prometheus_stack_namespace" {
  description = "Namespace of the Prometheus Stack install Helm Chart"
  type        = string
  default     = "monitoring"
}

# variable "cert_manager_namespace" {
#   description = "Kubernetes Namespace of the Cert Manager Helm Chart"
#   type        = string
#   default     = "cert-manager"
# }

# variable "cert_manager_version" {
#   description = "Version of Cert Manager to install"
#   type        = string
# }

variable "ecr_repository_name" {
  description = "Name of the ECR repository."
  type        = string
}

variable "identifier" {
  description = "Name of the RDS Instance Database."
  type        = string
}

variable "db_name" {
  type        = string
  description = "Name of the RDS Database."
}
variable "db_username" {
  type        = string
  description = "Username of the RDS Database."
}
variable "name_security_group" {
  type        = string
  description = "Name of the Security Group."

}