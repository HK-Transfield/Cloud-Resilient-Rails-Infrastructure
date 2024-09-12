# AWS Hosted Ruby-On-Rails Web Application ♦

The goal of this project is to help with familiarising
yourself with deploying an entire infrastructure in
AWS using Terraform.

The infrastructure is comprised  of a app server and database spun up with cloud resiliency features
(i.e. Load balancers, Autoscaling) using Terraform. Using this project assumes you have general
knowledge of AWS security best practices, like private subnets etc.

When deployed, it should display a webpage accessible through any web browser. This uses Ruby-on-Rails
as the server-side web application framework. It would have a domain that would show it alternating
between two Availability Zones via the Application Load Balancer.

## Architecture Overview 🏗️

![Architecture of the project](/docs/img/architecture-new.png)

The project deploys a Multi-AZ Ruby-on-Rails web application with the following tiers:

1. **Web Subnet:** A *public* facing Application Load Balancer with NAT Gateways for private internet connections.
2. **Application Subnet:** A *private* Auto Scaling Group for spinning up another EC2 instance of the Rails webapp in required.
3. **Database Subnet:** A *private* RDS database with Multi-AZ configured.

<!-- SECTION DISCUSSING VPC -->



<!-- SECTION DISCUSSING ALB -->



<!-- SECTION DISCUSSING AUTO SCALING GROUP -->



<!-- SECTION DISCUSSING APPLICATION SERVER -->



<!-- SECTION DISCUSSING DATABASE CONFIGURATION -->

