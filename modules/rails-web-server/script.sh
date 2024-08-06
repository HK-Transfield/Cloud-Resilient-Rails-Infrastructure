# Install RVM
sudo yum update
sudo yum install gcc
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm get head
rvm install 3.2.2

# Install sqlite
sudo amazon-linux-extras install epel
sudo yum install sqlite

# Verify version installed
ruby --version
sqlite3 --version
sleep 5

# Install Rails
gem install rails
rails --version
sleep 5

# Create web app
rails new webapp
cd webapp
bin/rails server