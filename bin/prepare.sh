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

# Remove results
echo "Deleting results..."
rm -rf /var/www/html/results/1*

# Clean tdnf repo
tdnf clean all
