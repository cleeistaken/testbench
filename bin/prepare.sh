#! /bin/bash

#
# This scrips prepares the system before exporting
# as an OVA
#

OVFCONF_RAN="/etc/ovfconf"
SSH_KNOWN_HOSTS_FILE="~/.ssh/known_hosts"
BASH_HISTORY_FILE="~/.bash_history"

#
# VMware KB 82228
#
echo "Resetting the machine ID"
echo -n > /etc/machine-id
if [ -f /var/lib/dbus/machine-id ]; then
  echo "Reset the dbus machine-id"
  rm -f /var/lib/dbus/machine-id
  ln -s /etc/machine-id /var/lib/dbus/machine-id
fi

# Bash history
if [ -f "${BASH_HISTORY_FILE}" ]; then
  echo "Deleting bash history"
  rm -f "${BASH_HISTORY_FILE}"
fi

# SSH known hosts
if [ -f "${SSH_KNOWN_HOSTS_FILE}" ]; then
  echo "Deleting known hosts"
  rm -f "${SSH_KNOWN_HOSTS_FILE}"
fi

# Clean repository
echo "Clean yum repository"
dnf clean all

# Remove results
echo "Deleting results..."
rm -rf /var/www/html/results/*

# Remove config files
echo "Removing configuration files..."
rm -f ~/*.yml
rm -f ~/*.tfvars
rm -f ~/.gifconfig

# Remove all log files
echo "Deleting log files..."
find /var/log -type f -delete
find /var/log -type f -regex ".*\.gz$" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete

# Remove ovfconf
echo "Removing ovfconf file"
rm -f "${OVFCONF_RAN}"

# Trim free blocks
echo "Trimming disk space"
fstrim /

echo "Done."
