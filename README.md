# AWS Hosted Ruby-On-Rails Web Application 

## Usage ⌨️

```bash
terraform init
terraform plan
terraform apply -var="my_ip=0.0.0.0/0" # replace with your IP to restrict SSH access to EC2 instances
```

## Overview 📋

This project aims to help familiarise yourself with deploying an entire cloud-hosted infrastructure in AWS using Terraform.

The infrastructure is comprised of a app server and database spun up with cloud resiliency features, 
such a web-facing Application Load Balancer and Auto Scaling Groups. Using this project assumes you have general
knowledge of AWS security best practices and understand how to use Terraform.

When deployed, it should display a webpage accessible through any web browser. This uses Ruby-on-Rails
as the server-side web application framework. It would have a domain that would show it alternating
between two Availability Zones via the Application Load Balancer.

## High-level Architecture 🏗️

![Architecture of the project](/imgs/architecture-new.png)

The project deploys a Multi-AZ Ruby-on-Rails web application with the following tiers:

1. **Web Subnet:** A *public* facing Application Load Balancer with NAT Gateways for private internet connections.
2. **App Subnet:** A *private* Auto Scaling Group for spinning up another EC2 instance of the Rails webapp in required.
3. **Database Subnet:** A *private* RDS database with Multi-AZ configured.

