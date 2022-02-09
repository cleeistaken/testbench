#! /bin/bash

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

