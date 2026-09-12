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
  - `provider.tf`:
  - `variables.tf`:
  - `terraform.tfvars`:
  - `vpc.tf`:
  - `security_groups.tf`:
  - `iam.tf`:
  - `ec2.tf`:
  - `outputs.tf`:
3. Initialize Terraform
  - `terraform init` - <img width="1640" height="367" alt="image" src="https://github.com/user-attachments/assets/73cb5658-f9b6-4edb-bbfd-12df29122d2a" />
  - `terraform fmt` and `terraform validate` - <img width="1685" height="82" alt="image" src="https://github.com/user-attachments/assets/48973e89-2604-455d-9dc1-13a0cfbb69d4" />
  - `terraform plan` - <img width="1660" height="822" alt="image" src="https://github.com/user-attachments/assets/94b27215-bbc7-4ef6-83ba-0a26f2cd1e44" /> <img width="956" height="837" alt="image" src="https://github.com/user-attachments/assets/468741ae-f8e4-4fec-b3e1-2f116065c643" />
  - `terraform apply` - <img width="1682" height="921" alt="image" src="https://github.com/user-attachments/assets/e9ff34bb-6164-4491-95a5-ec6cde07c475" /> <img width="1275" height="917" alt="image" src="https://github.com/user-attachments/assets/3213baa9-9e31-4ee2-9ee0-931a087b5191" />
  - `terraform output` - <img width="1661" height="190" alt="image" src="https://github.com/user-attachments/assets/25a9ed63-567b-402b-8a7a-44d0657ebfc6" />

### Step 3:  Install Ansible
  1. Open and update Ubuntu - `sudo apt update`, `sudo apt upgrade -y`
  2. Install Ansible - `sudo apt install -y ansible` - <img width="1372" height="235" alt="image" src="https://github.com/user-attachments/assets/95e65832-5b59-41f7-a4da-23098629b75d" />
  3. 
