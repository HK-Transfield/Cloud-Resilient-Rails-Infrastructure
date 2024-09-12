# AWS Hosted Ruby-On-Rails Web Application

The goal of this project is to help with familiarising
yourself with deploying an entire infrastructure in
AWS using Terraform.

The infrastructure is comprised  of a app server and database spun up with cloud resiliency features
(i.e. Load balancers, Autoscaling) using Terraform. Using this project assumes you have general
knowledge of AWS security best practices, like private subnets etc.

When deployed, it should display a webpage accessible through any web browser. This uses Ruby-on-Rails
as the server-side web application framework. It would have a domain that would show it alternating
between two Availability Zones via the Application Load Balancer.

## Architecture Overview

![Architecture of the project](/img/architecture-new.png)

The project deploys a Multi-AZ Ruby-on-Rails web application with the following tiers:

1. **Web Subnet:** A *public* facing Application Load Balancer with NAT Gateways for private internet connections.
2. **Application Subnet:** A *private* Auto Scaling Group for spinning up another EC2 instance of the Rails webapp in required.
3. **Database Subnet:** A *private* RDS database with Multi-AZ configured.

## Network Architecture

### Virtual Private Cloud (VPC)

* Assigned a CIDR block of 10.17.0.0/16.

#### Subnets

##### Availability Zone A


| NAME     | CIDR          | AZ  | CustomIPv6Value |
| ---------- | --------------- | ----- | ----------------- |
| sn-db-A  | 10.17.16.0/20 | AZA | IPv6 01         |
| sn-app-A | 10.17.32.0/20 | AZA | IPv6 02         |
| sn-web-A | 10.17.48.0/20 | AZA | IPv6 03         |

##### Availability Zone B


| NAME     | CIDR           | AZ  | CustomIPv6Value |
| ---------- | ---------------- | ----- | ----------------- |
| sn-db-B  | 10.17.80.0/20  | AZB | IPv6 05         |
| sn-app-B | 10.17.96.0/20  | AZB | IPv6 06         |
| sn-web-B | 10.17.112.0/20 | AZB | IPv6 07         |

#### Internet Gateway

* An IGW is assigned to the VPC.

#### Route Tables

* A route table is attached to the VPC, and associated with the public web
  subnets in each AZ.
* The following default routes were added:

## Application Server Architecture

The Ruby-on-Rails application server runs on an EC2 instance. When launched, a bash script
is passed as user data to install the Ruby Version Manager (RVM), Rails, and any other dependencies the
instance needs. The script also logs the user-data output to the EC2 Systems Log

```bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    # Step 1: Install dependencies
    echo "Installing dependencies..."
    sudo yum update -y
    sudo yum install gcc -y
    sudo yum install git -y
    sudo yum install dirmngr --allowerasing -y
    echo "Installed dependencies"

    # Step 2: Install RVM
    echo "Installing RVM..."
    gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable --rails
    source ~/.rvm/scripts/rvm
    echo "Installed RVM"

    # Step 3: Install Ruby and Rails
    echo "Installing Ruby and Rails..."
    rvm install 3.3.4
    rvm --default use 3.3.4
    gem install rails
    echo "Installed Ruby and Rails"

    # Step 4: Verify installation
    sqlite3 --version
    ruby --version
    rails --version

    # Step 5: Create new rails app
    echo "Creating new Rails app..."
    rails new myapp
    cd myapp
    bin/rails server
    echo "Created new Rails app"

```
