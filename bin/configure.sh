#! /bin/bash

#
# Install system packages
echo "Installing system packages"
sudo yum -y install git

#
# Install Terraform
echo "Installing Terraform"
#./install_terraform.sh

#
# Install Python
echo "Installing Python"
#./install_python.sh

#
# Configure Python
echo "Creating Python virtual environment"
python3 -m venv $HOME/.python3-venv

# Activate the virtual environment
echo "Activating the virtual environment"
source $HOME/.python3-venv/bin/activate

# Upgrade python packages
echo "Upgrading pip and setuptools"
pip install --upgrade pip
pip install --upgrade setuptools

# Install required packages"
echo "Installing required packages"
pip install wheel ansible jmespath netaddr firewalld

# Configure the systems
pushd ../ansible > /dev/null
  sudo ./run.sh
popd > /dev/null
echo "Done."
