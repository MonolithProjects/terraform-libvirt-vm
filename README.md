# Libvirt VM Terraform module

[![GitHub Actions](https://github.com/MonolithProjects/terraform-libvirt-vm/workflows/Lint/badge.svg)](https://github.com/MonolithProjects/terraform-libvirt-vm/actions)
[![License](https://img.shields.io/github/license/MonolithProjects/terraform-libvirt-vm)](https://github.com/MonolithProjects/terraform-libvirt-vm/blob/master/LICENSE)
[![Terraform](https://badgen.net/badge/Terraform%20Registry/yes/blue?icon=terraform)](https://registry.terraform.io/modules/MonolithProjects/vm/libvirt/latest)

Terraform module for KVM/Libvirt Virtual Machine. This module will create a KVM Virtual Machine(s), configure it using Cloud Init and test the ssh connection. This module is using [dmacvicar/libvirt](https://github.com/dmacvicar/terraform-provider-libvirt) Terraform provider.

## What this module provides

- creates one or more VMs
- one NIC per domain, connected to the network using the **bridge interface**
- setup network interface using DHCP or static configuration
- cloud_init VM(s) configuration (Ubuntu+Netplan complient)
- test the ssh connection

## Tested on

- Ubuntu 20.04 TLS

## Parameters

| Parameter | Description | Default value
|-----------------|-----|-----
|os_img_url|URL to the OS image|https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
|autostart| Autostart the Domain| true
|vm_count|Number of VMs| 1
|index_start|From where the index start| 1
|vm_hostname_prefix|VM hostname prefix|vm
|memory|RAM in MB|1024
|hugepages|Use Hugepages|false
|vcpu|Number of vCPUs|1
|pool|Storage pool name|default
|system_volume|System Volume size (GB)|10
|share_filesystem.source|Directory of the host to be shared with the VM|null
|share_filesystem.target|Tag that is exported to the VM as a hint for where to mount the source|null
|share_filesystem.readonly|Enables exporting filesystem as a readonly mount|false
|share_filesystem.mode|Access mode (mapped, passtrough, squash)|null
|bridge|Bridge interface| "virbr0"
|dhcp|Use DHCP or Static IP settings|false
|ip_address|"List of static IP addresses|[ "192.168.123.101" ]
|ip_nameserver|Static IP addresses of a nameserver|192.168.123.1
|ip_gateway|Static IP addresses of a gateway|192.168.123.1
|ssh_admin|Admin user with ssh access|ssh-admin
|ssh_keys|List of public ssh keys| []
|local_admin|Admin user without ssh access|local-admin
|local_admin_passwd|Local admin user password|password_example
|time_zone|Time Zone|UTC
|ssh_private_key|Private key for SSH connection test|~/.ssh/id_ed25519

## Example

DHCP IP settings:

```hcl
terraform {
  required_version = ">= 0.13"
    required_providers {
      libvirt = {
        source  = "dmacvicar/libvirt"
        version = "0.6.3"
      }
    }
}

provider "libvirt" {
  uri = "qemu+ssh://hero@192.168.165.100/system"
}

module "vm" {
  source  = "MonolithProjects/vm/libvirt"
  version = "1.6.0"

  vm_hostname_prefix = "server"
  vm_count    = 3
  memory      = "2048"
  hugepages   = false
  vcpu        = 1
  pool        = "terra_pool"
  system_volume = 20

  dhcp        = true

  local_admin = "local-admin"
  ssh_admin   = "ci-user"
  ssh_private_key = "~/.ssh/id_ed25519"
  local_admin_passwd = "$6$rounds=4096$xxxxxxxxHASHEDxxxPASSWORD"
  ssh_keys    = [ 
    "ssh-ed25519 AAAAxxxxxxxxxxxxSSHxxxKEY example", 
    ]
  time_zone   = "CET"
  os_img_url  = "file:///home/myuser/ubuntu-20.04-server-cloudimg-amd64.img"
}

output "ip_addresses" {
  value = module.nodes
}
```

Static IP settings and Hugepages:

```hcl
terraform {
  required_version = ">= 0.13"
    required_providers {
      libvirt = {
        source  = "dmacvicar/libvirt"
        version = "0.6.3"
      }
    }
}

provider "libvirt" {
  uri = "qemu+ssh://hero@192.168.165.100/system"
}

module "vm" {
  source  = "MonolithProjects/vm/libvirt"
  version = "1.6.0"

  vm_hostname_prefix = "server"
  vm_count    = 3
  memory      = "2048"
  hugepages   = true
  vcpu        = 1
  pool        = "terra_pool"
  system_volume = 20
  share_filesystem = {
    source = "/tmp"
    target = "tmp"
    readonly = false
  }

  dhcp        = false
  ip_address  = [ 
                  "192.168.165.151",
                  "192.168.165.152",
                  "192.168.165.153" 
                ]
  ip_gateway  = "192.168.165.254"
  ip_nameserver = "192.168.165.104"

  local_admin = "local-admin"
  ssh_admin   = "ci-user"
  ssh_private_key = "~/.ssh/id_ed25519"
  local_admin_passwd = "$6$rounds=4096$xxxxxxxxHASHEDxxxPASSWORD"
  ssh_keys    = [ 
    "ssh-ed25519 AAAAxxxxxxxxxxxxSSHxxxKEY example", 
    ]
  time_zone   = "CET"
  os_img_url  = "file:///home/myuser/ubuntu-20.04-server-cloudimg-amd64.img"
}

output "outputs" {
  value = module.nodes
}
```

The shared directory from the example can be mounted inside the VM with command `sudo mount -t 9p -o trans=virtio,version=9p2000.L,rw tmp /host/tmp`

## Module output example

```hcl
output_data = {
  "ip_address" = [
    "192.168.165.151",
    "192.168.165.152",
    "192.168.165.153",
  ]
  "name" = [
    "server01",
    "server02",
    "server03",
  ]
}
```

## License

MIT

## Author Information

Created in 2020 by Michal Muransky
