#!/bin/bash

while getopts f: flag
do
  case "${flag}" in
    f) FORCE=true;;
  esac
done

echo "Warning: This script will reset the Hashicorp Vault tokens."
echo "All currently stored data in vault will be lost."


if [ -z ${FORCE+x} ]; then
  read -p "Are you sure? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo "Exiting."
    exit
  fi
else
  echo "Skipping user prompt: '-f' flag set."
fi

pushd ../ansible > /dev/null
  # Configure the systems
  ANSIBLE_LOCALHOST_WARNING=false
  export ANSIBLE_LOCALHOST_WARNING
  ansible-playbook vault-init.yml
