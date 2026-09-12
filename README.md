# Assignment on Deploying a MERN Application through Terraform and Ansible
Objective:
Gain practical experience in deploying a MERN stack application on AWS using
infrastructure automation with Terraform and configuration management with Ansible

## Part 1: Infrastructure Setup with Terraform
### 1. AWS and Terraform Setup
### Step 1: Configure AWS CLI and authenticate with your AWS account
1. Install AWS CLI - `aws configure`
```
AWS Access Key ID:     YOUR_ACCESS_KEY
AWS Secret Access Key: YOUR_SECRET_KEY
Default region name:   us-east-1
Default output format: json
```
### Step 2:  Initialize a new Terraform project targeting AWS
1. Create directory inside the main folder - `mkdir terraform` and `mkdir ansible`
2. Go into Terraform and create the required terraform files
  1. provider.tf -
  ```
  terraform {
    required_version = ">= 1.6.0"
  
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
      }
    }
  }
  
  provider "aws" {
    region = var.aws_region
  }
  ```
  2. variables.tf -
  ```
  variable "aws_region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
  }
  
  variable "project_name" {
    description = "Project name"
    type        = string
    default     = "travelmemory"
  }
  
  variable "vpc_cidr" {
    description = "VPC CIDR"
    type        = string
    default     = "10.0.0.0/16"
  }
  
  variable "public_subnet_cidr" {
    description = "Public subnet"
    type        = string
    default     = "10.0.1.0/24"
  }
  
  variable "private_subnet_cidr" {
    description = "Private subnet"
    type        = string
    default     = "10.0.2.0/24"
  }
  
  variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t3.micro"
  }
  
  variable "key_name" {
    description = "Existing AWS EC2 key pair"
    type        = string
  }
  
  variable "my_ip" {
    description = "Your public IP in CIDR notation"
    type        = string
  }
  ```
  3. terraform.tfvars -
  ```
  aws_region = "us-east-1"

  project_name = "travelmemory"
  
  key_name = "travelmemory-key"
  
  my_ip = "YOUR_PUBLIC_IP/32"
  ```
  4. vpc.tf -
  ```
  # ---------------------------------------------------------
  # VPC
  # ---------------------------------------------------------
  
  resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
  
    tags = {
      Name = "${var.project_name}-vpc"
    }
  }
  
  
  # ---------------------------------------------------------
  # Public Subnet
  # ---------------------------------------------------------
  
  resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_cidr
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = true
  
    tags = {
      Name = "${var.project_name}-public-subnet"
    }
  }
  
  
  # ---------------------------------------------------------
  # Private Subnet
  # ---------------------------------------------------------
  
  resource "aws_subnet" "private" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_subnet_cidr
    availability_zone = "${var.aws_region}a"
  
    tags = {
      Name = "${var.project_name}-private-subnet"
    }
  }
  
  
  # ---------------------------------------------------------
  # Internet Gateway
  # ---------------------------------------------------------
  
  resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
  
    tags = {
      Name = "${var.project_name}-igw"
    }
  }
  
  
  # ---------------------------------------------------------
  # Elastic IP for NAT Gateway
  # ---------------------------------------------------------
  
  resource "aws_eip" "nat" {
    domain = "vpc"
  
    tags = {
      Name = "${var.project_name}-nat-eip"
    }
  }
  
  
  # ---------------------------------------------------------
  # NAT Gateway
  # NAT Gateway MUST be in the public subnet
  # ---------------------------------------------------------
  
  resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public.id
  
    depends_on = [
      aws_internet_gateway.main
    ]
  
    tags = {
      Name = "${var.project_name}-nat"
    }
  }
  
  
  # ---------------------------------------------------------
  # Public Route Table
  # ---------------------------------------------------------
  
  resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
  
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main.id
    }
  
    tags = {
      Name = "${var.project_name}-public-route-table"
    }
  }
  
  
  # ---------------------------------------------------------
  # Public Route Table Association
  # Connects Public Subnet → Public Route Table
  # ---------------------------------------------------------
  
  resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
  }
  
  
  # ---------------------------------------------------------
  # Private Route Table
  # ---------------------------------------------------------
  
  resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
  
    route {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main.id
    }
  
    tags = {
      Name = "${var.project_name}-private-route-table"
    }
  }
  
  
  # ---------------------------------------------------------
  # Private Route Table Association
  # Connects Private Subnet → Private Route Table
  # ---------------------------------------------------------
  
  resource "aws_route_table_association" "private" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
  }
  ```
  5. security_groups.tf
  ```
  # ============================================
  # Web Server Security Group
  # ============================================
  
  resource "aws_security_group" "web" {
    name        = "${var.project_name}-web-sg"
    description = "Security group for TravelMemory web/application server"
    vpc_id      = aws_vpc.main.id
  
    # SSH - only from my public IP
    ingress {
      description = "SSH from my IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.my_ip]
    }
  
    # HTTP - allow users to access the application
    ingress {
      description = "HTTP access"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    # TravelMemory Backend
    ingress {
      description = "TravelMemory backend"
      from_port   = 3001
      to_port     = 3001
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    # Outbound traffic
    egress {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    tags = {
      Name = "${var.project_name}-web-sg"
    }
  }
  
  
  # ============================================
  # Database / MongoDB Security Group
  # ============================================
  
  resource "aws_security_group" "database" {
    name        = "${var.project_name}-db-sg"
    description = "Security group for TravelMemory MongoDB database"
    vpc_id      = aws_vpc.main.id
  
    # MongoDB - ONLY accessible from the Web EC2
    ingress {
      description     = "MongoDB traffic from web server"
      from_port       = 27017
      to_port         = 27017
      protocol        = "tcp"
      security_groups = [aws_security_group.web.id]
    }
  
    # Outbound traffic
    egress {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    tags = {
      Name = "${var.project_name}-database-sg"
    }
  }
  ```
  6. iam.tf -
  ```
  # ---------------------------------------------------------
  # IAM Role for EC2 Instances
  # ---------------------------------------------------------
  
  resource "aws_iam_role" "ec2_role" {
    name = "${var.project_name}-ec2-role"
  
    assume_role_policy = jsonencode({
      Version = "2012-10-17"
  
      Statement = [
        {
          Effect = "Allow"
  
          Principal = {
            Service = "ec2.amazonaws.com"
          }
  
          Action = "sts:AssumeRole"
        }
      ]
    })
  
    tags = {
      Name    = "${var.project_name}-ec2-role"
      Project = var.project_name
    }
  }
  
  
  # ---------------------------------------------------------
  # IAM Instance Profile
  # ---------------------------------------------------------
  # EC2 instances use the instance profile to assume the
  # IAM role above.
  
  resource "aws_iam_instance_profile" "ec2_profile" {
    name = "${var.project_name}-ec2-profile"
    role = aws_iam_role.ec2_role.name
  
    tags = {
      Name    = "${var.project_name}-ec2-profile"
      Project = var.project_name
    }
  }
  ```
  7. ec2.tf -
  ```
  # ---------------------------------------------------------
  # Ubuntu AMI
  # ---------------------------------------------------------
  
  data "aws_ami" "ubuntu" {
    most_recent = true
  
    owners = ["099720109477"]
  
    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
  
    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }
  }
  
  
  # ---------------------------------------------------------
  # Web Server EC2 Instance
  # Public Subnet
  # ---------------------------------------------------------
  
  resource "aws_instance" "web" {
    ami                         = data.aws_ami.ubuntu.id
    instance_type               = var.instance_type
    subnet_id                   = aws_subnet.public.id
    vpc_security_group_ids      = [aws_security_group.web.id]
    key_name                    = var.key_name
    associate_public_ip_address = true
  
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  
    root_block_device {
      volume_size = 20
      volume_type = "gp3"
    }
  
    tags = {
      Name = "${var.project_name}-web"
      Role = "web"
    }
  }
  
  
  # ---------------------------------------------------------
  # Database EC2 Instance
  # Private Subnet
  # ---------------------------------------------------------
  
  resource "aws_instance" "database" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.database.id]
    key_name               = var.key_name
  
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  
    root_block_device {
      volume_size = 20
      volume_type = "gp3"
    }
  
    tags = {
      Name = "${var.project_name}-database"
      Role = "database"
    }
  }
  ```
  8. outputs.tf -
  ```
  output "vpc_id" {
    value = aws_vpc.main.id
  }
  
  output "web_instance_id" {
    value = aws_instance.web.id
  }
  
  output "web_public_ip" {
    value = aws_instance.web.public_ip
  }
  
  output "web_private_ip" {
    value = aws_instance.web.private_ip
  }
  
  output "database_instance_id" {
    value = aws_instance.database.id
  }
  
  output "database_private_ip" {
    value = aws_instance.database.private_ip
  }
  
  output "web_public_dns" {
    value = aws_instance.web.public_dns
  }
  ```
