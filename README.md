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
