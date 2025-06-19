variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ca-central-1"
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of existing private subnet IDs. If not provided, new private subnets will be created in the specified VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (only used if creating new subnets)"
  type        = list(string)
  default = []
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair to use for EC2 instances"
  type        = string
  default     = null
}

variable "blue_ingress_ip" {
  description = "IP address or CIDR block allowed to SSH to the blue instance (e.g., '10.0.0.0/16' or '192.168.1.100/32')"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "blue-orange-ec2"
    ManagedBy   = "terraform"
  }
}