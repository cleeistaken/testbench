#! /bin/bash

ROOTKEY="/etc/vault.d/rootKey/rootkey"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [ ! -f $ROOTKEY ]; then
  echo "Vault rootkey is not set."
  exit 1
fi

value=$(<$ROOTKEY)
echo "Vault rootkey: ${value}"
