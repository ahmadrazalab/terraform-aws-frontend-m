# Enterprize-tf-lab Terraform Setup

This document outlines the steps to create the infrastructure for the enterprize-tf-lab project using Terraform.

## 1. AMI Creation

### Frontend-application AMI
1. **Create an instance**
2. **Install dependencies**
3. **Setup application**
4. **Create AMI**

### Backend-application AMI
1. **Create an instance**
2. **Install dependencies**
3. **Setup application**
4. **Create AMI**

## 2. Keypair

### Create a Keypair
- Generate a keypair for EC2 instances.

## 3. IAM Users and Policies

### Create IAM Users
1. **data-s3-keys**: Permissions: `put`, `get`
2. **logs-s3-keys**: Permissions: `put`, `get`
3. **uat-s3-keys**: Permissions: `put`, `get`, `delete`

## 4. EC2 Instances

### Create EC2 Instances from AMI
- Launch 3 instances from the frontend and backend AMIs.

## 5. Security Groups

### Create Security Groups
1. **ec2-sg**: Security group for EC2 instances.
2. **alb-sg**: Security group for the load balancer.
3. **rds-sg**: Security group for RDS instances.

## 6. Auto Scaling Group and Launch Template

### Create Auto Scaling Group
- Create a launch template and configure the auto scaling group.

## 7. Target Groups and Load Balancer

### Create Target Groups
- Create 2 target groups for the load balancer.

### Create Load Balancer
- Setup load balancer with target groups and listener rules.

## 8. RDS and Read Replica

### Setup RDS
1. **Create RDS instance**
2. **Create Read Replica**
3. **Execute queries** to setup 2 databases and create user/password for the application.
4. **Import databases** from S3 bucket.

## 9. S3 Buckets

### Create S3 Buckets
- Create 3 S3 buckets for different purposes.

## 10. ACM Certificate

### Setup ACM Certificate
- Request and validate an ACM certificate.

## 11. Custom VPC

### Create Custom VPC
1. **Private Subnet**: For RDS instances.
2. **Public Subnet**: For EC2 instances and load balancer.

## 12. Private OpenVPN

### Setup Private OpenVPN
- Create a server in the VPC to connect private resources.

## 13. Secrets Manager

### Setup Secrets Manager
1. **Git Clone Credentials**: Store and fetch git clone token.
2. **Database Credentials**: Store and update database username, password, host, and port.

## 14. Outputs

### Terraform Outputs
1. **Load Balancer Host**: Output the load balancer hostname.
2. **All Servers IP with Name**: Output the IP addresses of all servers with their names.
3. **ACM Record**: Output the ACM record to update in DNS.

## Conclusion

> This setup will provision a fully functional infrastructure for the enterprize-tf-lab project using Terraform, ensuring scalability, security, and manageability.

