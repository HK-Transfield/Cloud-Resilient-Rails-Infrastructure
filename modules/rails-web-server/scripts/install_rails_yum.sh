# Install dependencies
sudo yum update
sudo yum install gcc -y
sudo yum install git -y
sudo yum install dirmngr --allowerasing -y

# Install RVM
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable --rails
source ~/.rvm/scripts/rvm

# Install Ruby and Rails
rvm install 3.3.4
gem install rails

# Verify installation
sqlite3 --version
ruby --version
rails --version

# Create new rails app
rails new myapp
cd myapp