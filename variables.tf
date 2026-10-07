variable "region" {
  description = "AWS region to deploy into."
  type        = string
}

variable "profile" {
  description = "AWS CLI profile for preferred account"
  type        = string
}

variable "prefix" {
  description = "Prefix included in the name of most resources."
  type        = string
}

variable "environment" {
  description = "Target environment tag (e.g. dev, staging, prod)."
  type        = string
}

########## Networking ##########

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnets - ALB + jump host (jump host lives in index 0)."
  type        = list(string)
}

variable "dashboard_v1_subnet_cidrs" {
  description = "Private subnets - dashboard version 1 ASG."
  type        = list(string)
}

variable "dashboard_v2_subnet_cidrs" {
  description = "Private subnets - dashboard version 2 ASG."
  type        = list(string)
}

variable "counting_subnet_cidrs" {
  description = "Private subnets - counting ASG."
  type        = list(string)
}

########## Jump host ##########

variable "jump_instance_type" {
  description = "Instance type for the jump host."
  type        = string
}

variable "admin_cidr" {
  description = "CIDR allowed to SSH into the jump host. Use your own IP/32, not 0.0.0.0/0."
  type        = string
}

########## EC2 / launch templates ##########

variable "dashboard_v1_instance_type" {
  description = "Instance type for dashboard v1 ASG instances."
  type        = string
}

variable "dashboard_v2_instance_type" {
  description = "Instance type for dashboard v2 ASG instances."
  type        = string
}

variable "counting_instance_type" {
  description = "Instance type for counting ASG instances."
  type        = string
}

########## Auto Scaling (3 groups) ##########

variable "dashboard_v1_min_size" {
  description = "Minimum size of the dashboard v1 ASG."
  type        = number
}

variable "dashboard_v1_max_size" {
  description = "Maximum size of the dashboard v1 ASG."
  type        = number
}

variable "dashboard_v1_desired_capacity" {
  description = "Desired capacity of the dashboard v1 ASG."
  type        = number
}

variable "dashboard_v2_min_size" {
  description = "Minimum size of the dashboard v2 ASG."
  type        = number
}

variable "dashboard_v2_max_size" {
  description = "Maximum size of the dashboard v2 ASG."
  type        = number
}

variable "dashboard_v2_desired_capacity" {
  description = "Desired capacity of the dashboard v2 ASG."
  type        = number
}

variable "counting_min_size" {
  description = "Minimum size of the counting ASG."
  type        = number
}

variable "counting_max_size" {
  description = "Maximum size of the counting ASG."
  type        = number
}

variable "counting_desired_capacity" {
  description = "Desired capacity of the counting ASG."
  type        = number
}

variable "target_cpu_utilization" {
  description = "Target average CPU % for scaling policies on all 3 ASGs."
  type        = number
}

########## DNS / Certificate ##########

variable "domain_name" {
  description = "Real domain with an existing PUBLIC Route 53 hosted zone, e.g. example.com."
  type        = string
}

variable "dashboard_subdomain" {
  description = "Single subdomain for the dashboard, e.g. dashboard -> dashboard.example.com. Both v1 and v2 sit behind this one domain, split by ALB weighted routing."
  type        = string
}

variable "dashboard_v1_weight" {
  description = "ALB forward-action weight for dashboard v1 (blue/green split). dashboard_v1_weight + dashboard_v2_weight should add up to 100."
  type        = number
}

variable "dashboard_v2_weight" {
  description = "ALB forward-action weight for dashboard v2 (blue/green split). dashboard_v1_weight + dashboard_v2_weight should add up to 100."
  type        = number
}

variable "internal_domain" {
  description = "Private Route 53 zone used only inside the VPC for counting service discovery."
  type        = string
}

########## Health checks ##########

variable "dashboard_health_check_path" {
  description = "ALB health check path for dashboard target groups."
  type        = string
}

variable "counting_health_check_path" {
  description = "ALB health check path for the counting target group."
  type        = string
}
