# Script from https://github.com/rvm/ubuntu_rvm
gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable

sudo apt-get install software-properties-common -y

sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm -y

sudo usermod -a -G rvm $USER
sudo reboot

rvm --version
sleep 5

rvm install ruby
ruby --version
sqlite3 --version



