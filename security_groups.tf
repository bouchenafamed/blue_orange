# Security group for the Blue instance
resource "aws_security_group" "blue" {
  name_prefix = "blue-sg-"
  vpc_id      = var.vpc_id

  # Allow SSH from itself (for testing connectivity)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = true
    description = "SSH from self (for testing)"
  }

  # Allow SSH from specified IP if provided
  dynamic "ingress" {
    for_each = var.blue_ingress_ip != null ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.blue_ingress_ip]
      description = "SSH from specified IP"
    }
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "blue-security-group"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Security group for the Orange instance
resource "aws_security_group" "orange" {
  name_prefix = "orange-sg-"
  vpc_id      = var.vpc_id

  # Allow SSH from Blue instance only
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.blue.id]
    description     = "SSH from Blue instance"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "orange-security-group"
  })

  lifecycle {
    create_before_destroy = true
  }
}