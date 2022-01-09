#! /bin/bash
#
# If there's a new Terraform releases available, delete the current Terraform install and download the new one.
# Must be run from within the directory where terraform binaries should reside
#

echo "Install script requirements"
yum -y install jq unzip wget

DIR_INSTALLATION="/usr/local/bin"
DIR_TMP="/tmp"

TERRAFORM_RELEASE_LATEST=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | jq --raw-output '.tag_name' | cut -c 2-)
TERRAFORM_FILENAME="terraform_${TERRAFORM_RELEASE_LATEST}_linux_amd64.zip"
TERRAFORM_VERSION="terraform_${TERRAFORM_RELEASE_LATEST}"
TERRAFORM_BINARY_PATH="${DIR_INSTALLATION}/${TERRAFORM_VERSION}"

if [[ ! -e ${TERRAFORM_BINARY_PATH} ]]; then
   echo "Installing Terraform ${TERRAFORM_RELEASE_LATEST}..."

   pushd ${DIR_TMP} > /dev/null
      echo "Downloading ${TERRAFORM_FILENAME}..."
      wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_RELEASE_LATEST}/${TERRAFORM_FILENAME}

      if [ -f "$TERRAFORM_FILENAME" ]; then
         echo "Extracting the terraform binary"
         unzip -o "${TERRAFORM_FILENAME}" -d "${TERRAFORM_BINARY_PATH}"

         echo "Remove zip file"
         rm -f "${TERRAFORM_FILENAME}"
      else
         echo "Failed to download the terraform binary."
         exit 1
      fi
   popd > /dev/null

else
     echo "Latest Terraform is already installed."
fi

echo "Removing the current link '${DIR_INSTALLATION}/terraform'"
rm -f "${DIR_INSTALLATION}/terraform"

echo "Setting 'terraform' to '${TERRAFORM_BINARY_PATH}/terraform'"
ln -f -s "${TERRAFORM_BINARY_PATH}/terraform" "${DIR_INSTALLATION}/terraform"

echo "Done."
