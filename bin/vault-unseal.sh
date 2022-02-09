#!/bin/bash

while getopts f: flag
do
  case "${flag}" in
    f) FORCE=true;;
  esac
done

echo "This script will unseal the Hashicorp Vault."

if [ "$FORCE" == true ]; then
  echo "Skipping user prompt: '-f' flag set."
else
  read -p "Are you sure? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo "Exiting."
    exit
  fi
fi

pushd ../ansible > /dev/null
  # Configure the systems
  ANSIBLE_LOCALHOST_WARNING=false
  export ANSIBLE_LOCALHOST_WARNING
  ansible-playbook vault-unseal.yml
popd > /dev/null