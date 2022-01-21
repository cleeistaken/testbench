#! /bin/bash

OVFCONF_RAN="/etc/ovfconf"
VMTOOLS_CMD="vmtoolsd"

if [ -e ${OVFCONF_RAN} ]; then
  echo "Customization already ran. To re-run, delete the file ${OVFCONF_RAN}"
  exit
fi

if ! command -v "${VMTOOLS_CMD}" &>/dev/null; then
  echo "The command '${VMTOOLS_CMD}' could not be found"
  exit 1
fi

NETWORK_SCRIPT_FILE="/etc/sysconfig/network-scripts/ifcfg-ens192"
NETWORK_SCRIPT_UUID=$(cat ${NETWORK_SCRIPT_FILE} | grep UUID | awk -F '=' '{printf $2}')

OVF_NET_CONF_TYPE=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_configuration_type' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_ADDRESS=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_ipv4_address' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_NETMASK=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_ipv4_netmask' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_GATEWAY=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_ipv4_gateway' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_DNS1=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_ipv4_dns1' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_DNS2=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_ipv4_dns2' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_SYS_ROOT_PASSWORD=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'system_root_password' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')

##################################
### Root password              ###
##################################
if [ -z "{OVF_SYS_ROOT_PASSWORD}" ]; then
  echo "Setting root password"
  echo "${OVF_SYS_ROOT_PASSWORD}" | passwd --stdin root
fi

##################################
### Network                    ###
##################################
if [ -z ${NETWORK_SCRIPT_UUID} ]; then
  echo "Generating an interface UUID"
  NETWORK_SCRIPT_UUID=$(uuidgen)
fi

if [ "${OVF_NET_CONF_TYPE}" == "Static" ]; then
  ##################################
  ### Static                     ###
  ##################################
  echo "IPv4 Static configuration"
  echo "IPv4 Address: ${OVF_NET_IPV4_ADDRESS}"
  echo "IPv4 Netmask: ${OVF_NET_IPV4_NETMASK}"
  echo "IPv4 Gateway: ${OVF_NET_IPV4_GATEWAY}"
  echo "IPv4 DNS1: ${OVF_NET_IPV4_DNS1}"
  echo "IPv4 DNS2: ${OVF_NET_IPV4_DNS2}"
  cat >"${NETWORK_SCRIPT_FILE}" <<__NETWORK_SCRIPT__
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
IPADDR=${OVF_NET_IPV4_ADDRESS}
NETMASK=${OVF_NET_IPV4_NETMASK}
GATEWAY=${OVF_NET_IPV4_GATEWAY}
DNS1=${OVF_NET_IPV4_DNS1}
DNS2=${OVF_NET_IPV4_DNS2}
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME=ens192
UUID=${NETWORK_SCRIPT_UUID}
DEVICE=ens192
ONBOOT=yes
__NETWORK_SCRIPT__
else
  ##################################
  ### DHCP                       ###
  ##################################
  echo "IPv4 DHCP configuration"
  cat >"${NETWORK_SCRIPT_FILE}" <<__NETWORK_SCRIPT__
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME=ens192
UUID=${NETWORK_SCRIPT_UUID}
DEVICE=ens192
ONBOOT=yes
__NETWORK_SCRIPT__
fi

# Configuration has run
date >"${OVFCONF_RAN}"
echo "Done"

