# Data source to get the specified VPC
data "aws_vpc" "main" {
  id = var.vpc_id
}

# Data source to get existing private subnets if provided
data "aws_subnets" "existing_private" {
  count = length(var.private_subnet_ids) > 0 ? 1 : 0
  filter {
    name   = "subnet-id"
    values = var.private_subnet_ids
  }
}

# Create private subnets if not provided
resource "aws_subnet" "private" {
  count = length(var.private_subnet_ids) == 0 ? length(var.private_subnet_cidrs) : 0

  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, {
    Name = "private-subnet-${count.index + 1}"
  })
}

# Local value to reference the private subnets
locals {
  private_subnet_ids = length(var.private_subnet_ids) > 0 ? var.private_subnet_ids : aws_subnet.private[*].id
}