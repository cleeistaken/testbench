#! /bin/bash

#
# This scrips prepares the system before exporting
# as an OVA
#

#
# VMware KB 82228
#
echo "Resetting the machine ID"
echo -n > /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

file="~/.bash_history"
if test -f "$file"; then
  echo "Deleting bash history"
  rm -f "$file"
fi

file="~/.ssh/known_hosts"
if test -f "$file"; then
  echo "Deleting known hosts"
  rm -f "$file"
fi

echo "Clean yum repository"
yum clean all

# Remove results
echo "Deleting results..."
rm -rf /var/www/html/results/*

# Remove all log files
echo "Deleting log files..."
find /var/log -type f -delete
find /var/log -type f -regex ".*\.gz$" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete

echo "Trimming disk space"
fstrim /

echo "Done."
