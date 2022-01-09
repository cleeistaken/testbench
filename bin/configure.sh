#! /bin/bash

# Install Terraform
echo "Installing Terraform"
./install_terraform.sh

#
# Install Python
echo "Installing Python3"
yum -y install python3


# Upgrade python packages
echo "Upgrading pip and setuptools"
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade setuptools

# Install required packages"
echo "Installing required packages"
pip install wheel ansible jmespath netaddr

# Configure the systems
pushd ../ansible > /dev/null
  ./run.sh
popd > /dev/null
echo "Done."
