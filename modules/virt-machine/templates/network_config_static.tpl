version: 2
ethernets:
  ens3:
    dhcp4: no
    addresses: [${ip_address}/24]
    gateway4: ${ip_gateway}
    nameservers:
       addresses: 
        - ${ip_nameserver}
        - 8.8.8.8