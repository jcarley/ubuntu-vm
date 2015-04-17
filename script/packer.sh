#!/bin/bash

version='0.7.5'

# install wget
sudo apt-get update
sudo apt-get install -y wget unzip vim

sudo mkdir /usr/lib/packer
sudo mkdir /usr/lib/packer/${version}

sudo wget https://dl.bintray.com/mitchellh/packer/packer_${version}_linux_amd64.zip -O /usr/lib/packer/${version}/${version}_linux_amd64.zip
sudo unzip /usr/lib/packer/${version}/${version}_linux_amd64.zip -d /usr/lib/packer/${version}
sudo unlink /usr/lib/packer/current || true
sudo ln -s /usr/lib/packer/${version} /usr/lib/packer/current
sudo rm /usr/lib/packer/${version}/${version}_linux_amd64.zip

sed -i '4i export PATH=/usr/lib/packer/current:$PATH' $HOME/.bashrc

