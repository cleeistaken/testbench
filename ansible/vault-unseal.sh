#!/bin/bash

# Configure the systems
ANSIBLE_LOCALHOST_WARNING=false
export ANSIBLE_LOCALHOST_WARNING
ansible-playbook vault-unseal.yml
