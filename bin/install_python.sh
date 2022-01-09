#! /bin/bash

# This script will build and install Pythion 3.x on
# a Centos 8 system

VERSION=3.10.1
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
  wget https://www.python.org/ftp/python/${VERSION}/${PYTHON_PACKAGE}

  if [ ! -f "${PYTHON_PACKAGE}" ]; then
    echo "Failed to download the package"
    exit 1
  fi

  echo "Extracting the contents of ${PYTHON_PACKAGE}"
  tar -xf "${PYTHON_PACKAGE}"

  echo "Remove python source package"
  rm -f "${PYTHON_PACKAGE}"

  pushd "${PYTHON_VERSION}" > /dev/null
    echo "Configure python build"
    ./configure --enable-optimizations  

    echo "Build and compile"
    make -j 4

    echo "Install python to alternate location"
    sudo make altinstall
  popd > /dev/null

popd > /dev/null
