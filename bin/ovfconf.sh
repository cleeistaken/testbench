#! /bin/bash

OVFCONF_RAN="/etc/ovfconf"
VMTOOLS_CMD="vmtoolsd"
NETWORK_INTERFACE="ens192"

if [ -e ${OVFCONF_RAN} ]; then
  echo "Customization already ran. To re-run, delete the file ${OVFCONF_RAN}"
  exit
fi

if ! command -v "${VMTOOLS_CMD}" &>/dev/null; then
  echo "The command '${VMTOOLS_CMD}' could not be found"
  exit 1
fi

OVF_NET_CONF_TYPE=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_configuration_type' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_ADDRESS=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_ipv4_address' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_NETMASK=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_ipv4_netmask' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_GATEWAY=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_ipv4_gateway' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_DNS1=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_ipv4_dns1' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_DNS2=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'network_ipv4_dns2' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_SYS_ROOT_PASSWORD=$(${VMTOOLS_CMD} --cmd 'info-get guestinfo.ovfEnv' | grep 'system_root_password' | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')
OVF_NET_IPV4_CIDR=$(echo ${OVF_NET_IPV4_NETMASK} | awk -F. '{ split($0, octets); for (i in octets) { mask += 8 - log(2**8 - octets[i])/log(2) } print mask }')



##################################
### Root password              ###
##################################
# https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
if [ ! -z "${OVF_SYS_ROOT_PASSWORD+x}" ]; then
  echo "Setting root password"
  echo "${OVF_SYS_ROOT_PASSWORD}" | passwd --stdin root
fi


##################################
### Network                    ###
##################################
if [ "${OVF_NET_CONF_TYPE}" == "Static" ]; then

  # Static
  echo "IPv4 Static configuration"
  echo "IPv4 Address: ${OVF_NET_IPV4_ADDRESS}"
  echo "IPv4 Netmask: ${OVF_NET_IPV4_NETMASK}"
  echo "IPv4 Gateway: ${OVF_NET_IPV4_GATEWAY}"
  echo "IPv4 DNS1: ${OVF_NET_IPV4_DNS1}"
  echo "IPv4 DNS2: ${OVF_NET_IPV4_DNS2}"
  echo "IPv4 CIDR: ${OVF_NET_IPV4_CIDR}"
  nmcli connection modify "${NETWORK_INTERFACE}" ipv4.addresses "${OVF_NET_IPV4_ADDRESS}/${OVF_NET_IPV4_CIDR}"
  nmcli connection modify "${NETWORK_INTERFACE}" ipv4.gateway "${OVF_NET_IPV4_GATEWAY}"
  nmcli connection modify "${NETWORK_INTERFACE}" ipv4.dns "${OVF_NET_IPV4_DNS1} ${OVF_NET_IPV4_DNS2}"
  nmcli connection modify "${NETWORK_INTERFACE}" ipv4.method manual
  nmcli connection down "${NETWORK_INTERFACE}"
  nmcli connection up "${NETWORK_INTERFACE}"

else

  # DHCP
  echo "IPv4 DHCP configuration"
  nmcli device modify "${NETWORK_INTERFACE}" ipv4.method auto
  nmcli connection down "${NETWORK_INTERFACE}"
  nmcli connection up "${NETWORK_INTERFACE}"
   
fi


##################################
### Configuration has run      ###
##################################
date > "${OVFCONF_RAN}"
echo "${OVF_NET_CONF_TYPE}" >> "${OVFCONF_RAN}"
nmcli device show "${NETWORK_INTERFACE}" >> "${OVFCONF_RAN}"
echo "Done"
