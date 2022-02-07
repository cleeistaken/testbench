#! /bin/bash
#
# If there's a new Vault release available, delete the current version, download the new one, and install.
# Must be run from within the directory where vault binaries should reside
#

echo "Install script requirements"
sudo yum -y install jq unzip wget

DIR_INSTALLATION="/usr/local/bin"
DIR_TMP="/tmp"

VAULT_BINARY="vault"
VAULT_RELEASE_LATEST=$(curl -s https://api.github.com/repos/hashicorp/vault/releases/latest | jq --raw-output '.tag_name' | cut -c 2-)
VAULT_FILENAME="vault_${VAULT_RELEASE_LATEST}_linux_amd64.zip"
VAULT_VERSION="vault_${VAULT_RELEASE_LATEST}"
VAULT_BINARY_PATH="${DIR_INSTALLATION}/${VAULT_VERSION}"

if [[ ! -e ${VAULT_BINARY_PATH} ]]; then
   echo "Installing Vault ${VAULT_RELEASE_LATEST}..."

   pushd ${DIR_TMP} > /dev/null
      echo "Downloading ${VAULT_FILENAME}..."
      wget -q https://releases.hashicorp.com/vault/${VAULT_RELEASE_LATEST}/${VAULT_FILENAME}

      if [ -f "$VAULT_FILENAME" ]; then
         echo "Extracting the vault binary"
         sudo unzip -o "${VAULT_FILENAME}" -d "${VAULT_BINARY_PATH}"

         echo "Remove zip file"
         rm -f "${VAULT_FILENAME}"
      else
         echo "Failed to download the vault binary."
         exit 1
      fi
   popd > /dev/null

else
     echo "Latest Vault is already installed."
fi

echo "Removing the current link '${DIR_INSTALLATION}/${VAULT_BINARY}'"
sudo rm -f "${DIR_INSTALLATION}/${VAULT_BINARY}"

echo "Setting 'vault' to '${VAULT_BINARY_PATH}/${VAULT_BINARY}'"
sudo ln -f -s "${VAULT_BINARY_PATH}/${VAULT_BINARY}" "${DIR_INSTALLATION}/${VAULT_BINARY}"

echo "Done."
