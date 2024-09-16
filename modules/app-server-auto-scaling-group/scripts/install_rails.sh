#!/bin/bash -xe

sudo yum install git -y
git clone https://github.com/HK-Transfield/Amazon-Linux-Rails-Installer 
cd Amazon-Linux-Rails-Installer 
chmod +x install.sh
./install.sh