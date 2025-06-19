# Blue-Orange EC2 Infrastructure

This Terraform configuration provisions two EC2 instances named "blue" and "orange" with specific SSH access controls in AWS.

## Features

✅ **Latest Ubuntu 24.04 LTS ARM64 AMI**: Automatically fetches the most recent stable Ubuntu 24.04 ARM64 AMI
✅ **Private Subnet Deployment**: Both instances are deployed in private subnets
✅ **Controlled SSH Access**: Blue can SSH to Orange, Orange cannot SSH to Blue
✅ **Optional External Access**: Can allow SSH to Blue from specified IP address or from resources that have blue security group
✅ **Flexible Subnet Support**: Works with existing private subnets or creates new ones in existing VPC
✅ **Multi-Region Support**: Can be deployed to any AWS region (default: ca-central-1)
✅ **ARM Architecture**: Uses t4g.micro instances for cost efficiency
✅ **Auto SSH Keys**: Automatically generates secure SSH key pairs

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate permissions
- AWS account with permissions to create EC2, security groups, subnets, and key pairs
- **Existing VPC** where resources will be deployed

## Quick Start

1. **Clone and navigate to the directory**:

   ```bash
   cd blue_orange
   ```

2. **Copy the example variables file**:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit terraform.tfvars**:
   - Set your VPC ID (required)
   - Configure subnet settings (use existing or create new)
   - Set your preferred AWS region (default: ca-central-1)
   - Optionally set blue_ingress_ip for external SSH access
   - Customize tags as needed

4. **Initialize Terraform**:

   ```bash
   terraform init
   ```

5. **Review the plan**:

   ```bash
   terraform plan
   ```

6. **Apply the configuration**:

   ```bash
   terraform apply
   ```

## Configuration Options

### Using Existing Private Subnets

If you have existing private subnets in your VPC:

```hcl
# In terraform.tfvars
vpc_id = "vpc-12345678"
private_subnet_ids = ["subnet-12345678", "subnet-87654321"]
```

### Creating New Private Subnets

If you want to create new private subnets in your existing VPC:

```hcl
# In terraform.tfvars
vpc_id = "vpc-12345678"
# Leave private_subnet_ids empty or commented out
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
```

### Instance Type

The default instance type is `t4g.micro` (ARM-based). You can change it to any ARM instance type:

```hcl
# In terraform.tfvars
instance_type = "t4g.small"  # or t4g.medium, etc.
```

### Ingress rule for SSH Access

To allow SSH access to the Blue instance from a specific IP address:

```hcl
# In terraform.tfvars
blue_ingress_ip = "10.0.1.100/32"  # Your IP address with /32 for single IP
# or
blue_ingress_ip = "10.0.0.0/16"       # Or use a CIDR block
```

## SSH Access

### SSH Key Management

The configuration automatically generates SSH key pairs for secure access. After deployment:

1. **Save the private key** from the `ssh_private_key` output to a file:

   ```bash
   terraform output -raw ssh_private_key > blue_orange_key.pem
   chmod 600 blue_orange_key.pem
   ```

2. **Use the key for SSH connections**:

   ```bash
   ssh -i blue_orange_key.pem ubuntu@<instance-ip>
   ```

### Accessing Instances

Since instances are in private subnets, you'll need to:

- Use an VPC Endpoint that uses blue security group
- or Set up a bastion host in a public subnet in the CIDR used as ingress rule for blue security group or attach blue security group to the bastion

## Security Groups

- **Blue Security Group**:
  - Allows SSH from itself (for testing)
  - Allows SSH from specified IP (if blue_ingress_ip is set)
- **Orange Security Group**:
  - Allows SSH from instances attached to Blue Security Group

## Outputs

After successful deployment, Terraform will output:

- Instance IDs and private IPs
- VPC and subnet IDs
- Security group IDs
- SSH key information (name, public key, private key)
- SSH connection information

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Troubleshooting

### Common Issues

1. **VPC Not Found**: Ensure the VPC ID is correct and exists in the specified region
2. **Subnet CIDR Conflicts**: If creating new subnets, ensure CIDR blocks don't conflict with existing subnets
3. **AMI Not Found**: Ensure you're in a region where Ubuntu 24.04 ARM64 AMIs are available
4. **Insufficient Permissions**: Ensure AWS credentials have necessary permissions
5. **SSH Key Permissions**: Ensure the private key file has 600 permissions
6. **Connectivity Issues**: Use the self-SSH capability to test connectivity from within the Blue instance

### Getting Help

Check the Terraform outputs for resource information and connection details. The `ssh_private_key` output contains the private key needed for SSH access.
