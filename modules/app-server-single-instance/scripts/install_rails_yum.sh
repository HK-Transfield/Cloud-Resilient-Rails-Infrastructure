#!/bin/bash -xe
#################################################
# Title: Amazon Linux 2 Rails Installation Script
# Author: HK Transfield
#################################################

# This script logs user-data output to system logs of an EC2 instance
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