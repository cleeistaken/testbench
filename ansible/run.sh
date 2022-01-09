#!/bin/bash 

# Activate the virtual environment
echo "Activating the environment"
source $HOME/.python3-venv/bin/activate

# Configure the systems
ANSIBLE_LOCALHOST_WARNING=false
export ANSIBLE_LOCALHOST_WARNING
~/.python3-venv/bin/ansible-playbook main.yml
