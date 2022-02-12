#! /bin/bash

echo "This script will perform the initial deploy and configuration of the system."
read -p "Are you sure? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "Exiting."
  exit
fi

# Install Python
echo "Installing Python3"
yum -y install python3 python3-pip

# Upgrade python packages
echo "Upgrading pip and setuptools"
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade setuptools

# Install required packages"
echo "Installing required packages"
python3 -m pip install wheel ansible jmespath netaddr

# Invoke Ansible host configuration
pushd ../ansible > /dev/null
  echo "Running ansible host configuration"
  ANSIBLE_LOCALHOST_WARNING=false
  export ANSIBLE_LOCALHOST_WARNING
  ansible-playbook playbook.yml
popd > /dev/null

echo "Done."
