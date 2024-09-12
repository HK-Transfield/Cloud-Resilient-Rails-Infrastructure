# AWS Hosted Ruby-On-Rails Web Application Infrastructure 

## Overview
![Architecture of the project](/img/architecture.png)

The goal of this project is to help with familiarising 
yourself with deploying an entire infrastructure in 
AWS using Terraform.

This project is a webserver and database spun up with cloud resiliency 
(i.e. Load balancers, Autoscaling) using Terraform. Must have general 
ecurity best practices, like a private subnet etc. 

When deployed correctly, it will display a webpage on a cloud-based 
infrastructure, this uses Ruby on Rails as the webserver and it would 
have a domain that would show it would alternate between the Availability 
zones.

If working correctly, the load balancer will alternate between the 2 AZs.

## Network Architecture

### Virtual Private Cloud (VPC)
* Assigned a CIDR block of 10.17.0.0/16.

#### Subnets
##### Availability Zone A
| NAME | CIDR | AZ | CustomIPv6Value |
|------|------|----|-----------------|
|sn-db-A | 10.17.16.0/20 | AZA | IPv6 01 |
|sn-app-A | 10.17.32.0/20 | AZA | IPv6 02 |
|sn-web-A | 10.17.48.0/20 | AZA | IPv6 03 |

##### Availability Zone B
| NAME | CIDR | AZ | CustomIPv6Value |
|------|------|----|-----------------|
| sn-db-B | 10.17.80.0/20 | AZB | IPv6 05 |
| sn-app-B | 10.17.96.0/20 | AZB | IPv6 06 |
| sn-web-B | 10.17.112.0/20 | AZB | IPv6 07 |

#### Internet Gateway
* An IGW is assigned to the VPC.

#### Route Tables
* A route table is attached to the VPC, and associated with the public web
subnets in each AZ.
* The following default routes were added:

## Web Server Architecture
The Ruby on Rails server runs on an EC2 instance.
