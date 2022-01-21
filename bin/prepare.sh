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
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Bash history
if test -f "${BASH_HISTORY_FILE}"; then
  echo "Deleting bash history"
  rm -f "${BASH_HISTORY_FILE}"
fi

# SSH known hosts
if test -f "${SSH_KNOWN_HOSTS_FILE}"; then
  echo "Deleting known hosts"
  rm -f "${SSH_KNOWN_HOSTS_FILE}"
fi

# Clean repository
echo "Clean yum repository"
yum clean all

# Remove results
echo "Deleting results..."
rm -rf /var/www/html/results/*

# Remove ovfconf
echo "Removing ovfconf file"
rm -f "${OVFCONF_RAN}"

# Trim free blocks
echo "Trimming disk space"
fstrim /

echo "Done."
