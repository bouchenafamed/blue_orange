# Generate SSH key pair for EC2 instances
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair
resource "aws_key_pair" "generated_key" {
  key_name   = "blue-orange-key-${formatdate("YYYYMMDD", timestamp())}"
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = merge(var.tags, {
    Name = "blue-orange-key-pair"
  })
}