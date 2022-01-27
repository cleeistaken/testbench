#! /bin/bash

OVFCONF_SVC_FILE="/usr/lib/systemd/system/ovfconf.service"

cat > "${OVFCONF_SVC_FILE}" << __OVFCONF_SERVICE__
[Unit]
Description=Service to configure the system using the ovf environment
After=vmtoolsd.service

[Service]
Type=simple
ExecStart=/opt/testbench/bin/ovfconf.sh
TimeoutStartSec=0

[Install]
WantedBy=default.target
__OVFCONF_SERVICE__

# Set permissions
chown root:root "${OVFCONF_SVC_FILE}"
chmod 644 "${OVFCONF_SVC_FILE}"

# Enable and Start Service
systemctl enable ovfconf
systemctl start ovfconf