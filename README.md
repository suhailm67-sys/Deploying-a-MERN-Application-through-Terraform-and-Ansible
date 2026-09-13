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

### Snapshots for reference from AWS console after completing Terraform:
<img width="1627" height="242" alt="image" src="https://github.com/user-attachments/assets/f39d7f05-625f-4579-aa0d-031d877882c6" />
<img width="1367" height="692" alt="image" src="https://github.com/user-attachments/assets/ea0bacd3-b15d-408d-a79f-b48725fd3668" />
<img width="1537" height="747" alt="image" src="https://github.com/user-attachments/assets/1303420b-6610-445b-8176-aa8349663992" />
<img width="1532" height="697" alt="image" src="https://github.com/user-attachments/assets/f47c636c-9106-4563-a3c3-a9054d60dd17" />
<img width="1545" height="301" alt="image" src="https://github.com/user-attachments/assets/0d71b73f-1f87-491e-a3e3-448f626a801f" />
<img width="1552" height="471" alt="image" src="https://github.com/user-attachments/assets/4f74572a-820a-4234-b9be-b2ee778efc35" />
<img width="1572" height="542" alt="image" src="https://github.com/user-attachments/assets/116718c1-5e4c-4219-90c4-4cf390c7f4e1" />

### Step 3:  Install Ansible
  1. Open and update Ubuntu - `sudo apt update`, `sudo apt upgrade -y`
  2. Install Ansible - `sudo apt install -y ansible` - <img width="1372" height="235" alt="image" src="https://github.com/user-attachments/assets/95e65832-5b59-41f7-a4da-23098629b75d" />
  3. Install boto3 and botocore - `sudo apt install -y python3-boto3 python3-botocore`
  4. Install and configure AWS Credentials in WSL - `sudo apt install -y awscli`, `aws configure`
  5. Install Git - `sudo apt install -y git`
  6. Create the Ansible Directory - `mkdir -p ~/TravelMemory/ansible/inventory`, `mkdir -p ~/TravelMemory/ansible/playbooks`, `mkdir -p ~/TravelMemory/ansible/templates`
  7. Tree - `tree ~/TravelMemory` - <img width="582" height="210" alt="image" src="https://github.com/user-attachments/assets/72d9e67a-4403-4efd-8768-6beced83f334" />
  8. Set Up Your Key and Copy the Key into WSL - `cp /mnt/c/Users/Administrator/Downloads/SSH_KEY.pem ~/.ssh/`
  9. Fix SSH Key Permissions - `chmod 400 ~/.ssh/SSH_KEY.pem`
  10. Test SSH to the Web EC2 -  `ssh -i ~/.ssh/SSH_KEY.pem ubuntu@44.200.32.208` - <img width="892" height="682" alt="image" src="https://github.com/user-attachments/assets/1d89d9ef-01ec-428b-a44b-534babd76267" />

## Part 2: Configuration and Deployment with Ansible
1. Create the configuration file: `nano ansible.cfg`
```
[defaults]
inventory = inventory/hosts.ini
remote_user = ubuntu
host_key_checking = False
private_key_file = ~/.ssh/SSH_KEY.pem
interpreter_python = auto_silent
```
2. Create the Ansible Inventory: `nano inventory/hosts.ini`
```
[web]
WEB_PUBLIC_IP ansible_user=ubuntu

[database]
DATABASE_PRIVATE_IP ansible_user=ubuntu ansible_ssh_common_args='-o ProxyJump=ubuntu@WEB_PUBLIC_IP'
```
3. Configure Ansible SSH Proxy: `nano ansible.cfg`
```
[defaults]
inventory = inventory/hosts.ini
remote_user = ubuntu
host_key_checking = False
private_key_file = ~/.ssh/SSH_KEY.pem
interpreter_python = auto_silent
```
4. Test Ansible: `ansible web -m ping` - <img width="760" height="195" alt="image" src="https://github.com/user-attachments/assets/863b73c8-568d-4856-bd68-581ab8464285" />
5. Test the database: `ansible database -m ping` - <img width="830" height="185" alt="image" src="https://github.com/user-attachments/assets/c297e044-421d-46d1-b7ca-8a51abe9e0f0" />
6. Create the Web Server Playbook: `nano playbooks/webserver.yml`
7. Run the Web Server Playbook: `ansible-playbook playbooks/webserver.yml` - <img width="1512" height="72" alt="image" src="https://github.com/user-attachments/assets/65f09249-ec54-476e-9d24-ce783f0f933d" />
8. MongoDB Installation Playbook: `nano playbooks/database.yml`
9. Run MongoDB Playbook: `ansible-playbook playbooks/database.yml` - <img width="1452" height="182" alt="image" src="https://github.com/user-attachments/assets/d145c905-3d3c-48bd-a630-b623f28fe0c3" />
<img width="1462" height="377" alt="image" src="https://github.com/user-attachments/assets/33547e90-2bba-4b3c-8a66-ea4fb3e18726" />
10. Configure MongoDB to listen on the private interface:
  - Connect: `ssh travelmemory-database`
  - Open: `sudo nano /etc/mongod.conf`
  - Find and change to: `bindIp: 127.0.0.1,10.0.2.15`
  - Restarte mongoDB: `sudo systemctl restart mongod`
  - Check: `sudo systemctl status mongod --no-pager` - <img width="1460" height="317" alt="image" src="https://github.com/user-attachments/assets/67c57ecf-db3c-4187-86c9-b7dd912e7a04" />
#### 11. Configure MongoDB authentication:
  1. Create the MongoDB administrator
    - On the database server: `mongosh`
    - At the MongoDB prompt: `use admin`
    - Create the administrator: 
    ```
    db.createUser({
      user: "admin",
      pwd: "CHANGE_THIS_TO_A_STRONG_PASSWORD",
      roles: [
        { role: "root", db: "admin" }
      ]
    })
    ```
  2. Create the TravelMemory application user:
    - Open MongoDB: `mongosh`
    - At the MongoDB prompt: `use travelmemory`
    - Create the TravelMemory application user:
    ```
    db.createUser({
      user: "travelmemoryapp",
      pwd: "CHANGE_THIS_TO_ANOTHER_STRONG_PASSWORD",
      roles: [
        { role: "readWrite", db: "travelmemory" }
      ]
    })
    ```
  3. Enable authentication: `sudo nano /etc/mongod.conf`
  4. Add: `security:   authorization: enabled`
  5. Restart: `sudo systemctl restart mongod` and verify: `sudo systemctl status mongod --no-pager`
12.
