# Blue EC2 instance
resource "aws_instance" "blue" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = local.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.blue.id]
  key_name               = aws_key_pair.generated_key.key_name

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true

    tags = merge(var.tags, {
      Name = "blue-root-volume"
    })
  }

  tags = merge(var.tags, {
    Name = "blue"
  })

  # Ensure the instance is launched in a private subnet
  depends_on = [aws_security_group.blue, aws_key_pair.generated_key]
}

# Orange EC2 instance
resource "aws_instance" "orange" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = local.private_subnet_ids[1 % length(local.private_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.orange.id]
  key_name               = aws_key_pair.generated_key.key_name

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true

    tags = merge(var.tags, {
      Name = "orange-root-volume"
    })
  }

  tags = merge(var.tags, {
    Name = "orange"
  })

  # Ensure the instance is launched in a private subnet
  depends_on = [aws_security_group.orange, aws_key_pair.generated_key]
}