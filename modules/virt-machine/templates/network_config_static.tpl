version: 2
ethernets:
  ens3:
    dhcp4: no
    addresses: [${ip_address}/24]
    gateway4: 192.168.123.254
    nameservers:
       addresses: 
        - 192.168.123.254
        - 8.8.8.8