#!/bin/bash

# Ref. https://stackoverflow.com/questions/31974550/boolean-cli-flag-using-getopts-in-bash

FORCE='false'

# Process all options supplied on the command line
while getopts ':f' 'OPTKEY'; do
    case ${OPTKEY} in
        'f')
            # Update the value of the option x flag we defined above
            FORCE='true'
            ;;
        *)
            echo "UNIMPLEMENTED OPTION -- ${OPTKEY}" >&2
            exit 1
            ;;
    esac
done

# [optional] Remove all options processed by getopts.
shift $(( OPTIND - 1 ))
[[ "${1}" == "--" ]] && shift

echo "Warning: This script will reset the Hashicorp Vault tokens."
echo "All currently stored data in vault will be lost."

if ${FORCE}; then
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
  echo "Initializing Hashicorp Vault keys"
  ANSIBLE_LOCALHOST_WARNING=false
  export ANSIBLE_LOCALHOST_WARNING
  ansible-playbook vault-init.yml
popd > /dev/null