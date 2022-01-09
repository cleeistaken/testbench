#! /bin/bash

# This script will build and install Pythion 3.x on
# a Centos 8 system

VERSION=3.10.1
VERSION_SHORT="${VERSION%.*}"
PYTHON_VERSION="Python-${VERSION}"
PYTHON_PACKAGE="${PYTHON_VERSION}.tgz"

DIR_TMP="/tmp"

# Install required system packages
echo "Installing required system packages"
sudo dnf -y groupinstall 'development tools'
sudo dnf -y install \
  bzip2-devel \
  expat-devel \
  gdbm-devel \
  ncurses-devel \
  openssl-devel \
  readline-devel \
  wget \
  sqlite-devel \
  tk-devel \
  xz-devel \
  zlib-devel \
  libffi-devel


pushd "${DIR_TMP}" > /dev/null
  echo "Downloading ${PYTHON_PACKAGE}"
  wget -q https://www.python.org/ftp/python/${VERSION}/${PYTHON_PACKAGE}

  if [ ! -f "${PYTHON_PACKAGE}" ]; then
    echo "Failed to download the package"
    exit 1
  fi

  echo "Extracting the contents of ${PYTHON_PACKAGE}"
  #tar -xf "${PYTHON_PACKAGE}"

  echo "Remove python source package"
  #rm -f "${PYTHON_PACKAGE}"

  pushd "${PYTHON_VERSION}" > /dev/null
    echo "Configure python build"
    #./configure --enable-optimizations  

    echo "Build and compile"
    #make -j 4

    echo "Install python to alternate location"
    #sudo make altinstall

    PYTHON_LOCATION="$(dirname $(which python${VERSION_SHORT}))"

    pushd "${PYTHON_LOCATION}" > /dev/null
      echo "Create links in ${PYTHON_LOCATION}"
      declare -a PYTHON_BINS=("idle" "pip" "pydoc" "python" "python-config")

      for i in "${PYTHON_BINS[@]}"
      do
        echo "Linking ${i}${VERSION_SHORT} to ${i}3"
        sudo ln -f -s "${i}${VERSION_SHORT}" "${i}3"
      done

    popd > /dev/null

  popd > /dev/null

popd > /dev/null

echo "Done."
