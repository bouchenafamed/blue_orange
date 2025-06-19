output "vpc_id" {
  description = "ID of the VPC"
  value       = var.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = local.private_subnet_ids
}

output "blue_instance_id" {
  description = "ID of the Blue EC2 instance"
  value       = aws_instance.blue.id
}

output "blue_private_ip" {
  description = "Private IP address of the Blue EC2 instance"
  value       = aws_instance.blue.private_ip
}

output "orange_instance_id" {
  description = "ID of the Orange EC2 instance"
  value       = aws_instance.orange.id
}

output "orange_private_ip" {
  description = "Private IP address of the Orange EC2 instance"
  value       = aws_instance.orange.private_ip
}

output "blue_security_group_id" {
  description = "ID of the Blue security group"
  value       = aws_security_group.blue.id
}

output "orange_security_group_id" {
  description = "ID of the Orange security group"
  value       = aws_security_group.orange.id
}

output "ssh_key_name" {
  description = "Name of the generated SSH key pair"
  value       = aws_key_pair.generated_key.key_name
}

output "ssh_private_key" {
  description = "Private SSH key for connecting to instances"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}

output "ssh_public_key" {
  description = "Public SSH key"
  value       = tls_private_key.ssh_key.public_key_openssh
}

output "ssh_connection_info" {
  description = "SSH connection information"
  value = {
    blue_to_orange = "ssh -i <private_key_file> ubuntu@${aws_instance.orange.private_ip} (from Blue instance)"
    blue_self_test = "ssh -i <private_key_file> ubuntu@${aws_instance.blue.private_ip} (from Blue instance to test connectivity)"
    orange_to_blue = "ssh -i <private_key_file> ubuntu@${aws_instance.blue.private_ip} (from Orange instance)"
    note           = "Blue can SSH to Orange and itself. Orange can SSH to Blue. No SSH from Internet unless blue_ingress_ip is specified."
    private_key_file = "Save the ssh_private_key output to a file with 600 permissions"
  }
} 