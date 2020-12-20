# Libvirt VM Terraform module

[![GitHub Actions](https://github.com/MonolithProjects/terraform-libvirt-vm/workflows/Lint/badge.svg)](https://github.com/MonolithProjects/terraform-libvirt-vm/actions)
[![License](https://img.shields.io/github/license/MonolithProjects/terraform-libvirt-vm)](https://github.com/MonolithProjects/terraform-libvirt-vm/blob/master/LICENSE)

Terraform module for KVM/Libvirt Virtual Machine. This module will create a libvirt domain, storage pool, system volume and configure the VM using cloud_init. This module is using [dmacvicar/libvirt](https://github.com/dmacvicar/terraform-provider-libvirt) Terraform provider.

> :warning: Module is not 100% universal and not all parameters are parametrized (yet). For example you may need to change bridge settings or cloud init.

## What the module provides

- create one or more libvirt domains
- create a storage pool
- create a system volume from the pool
- use cloud_init to configure VMs

## Parameters

| Parameter | Description | Default value
|-----------------|-----|-----
|libvirt_disk_path| Path to libvirt Disk pool|/mnt/terra
|os_img_url|URL to the OS image|https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
|vm_count|Number of VMs| 1
|vm_hostname_prefix|VM hostname prefix|vm
|memory|RAM in MB|512
|vcpu|Number of vCPUs|1
|system_volume|System Volume size (GB)|10
|dhcp|Use DHCP or Static IP settings|false
|ip_address|"List of IP addresses|[ "192.168.123.1" ]
|ip_nameserver|IP addresses of a nameserver|192.168.123.1
|ip_gateway|IP addresses of a gateway|192.168.123.1
|ssh_admin|Admin user with ssh access|ssh-admin
|ssh_keys|List of public ssh keys| []
|local_admin|Admin user without ssh access|local-admin
|local_admin_passwd|Local admin user password|password_example
|time_zone|Time Zone|UTC
|ssh_private_key|Private key for SSH connection test|~/.ssh/deployer_keys/id_ed25519

**Cloud_init** configuration can be found in `modules/virt-machine/templates`.

## Example

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

terraform {
  required_version = ">= 0.13"
}

provider "libvirt" {
  uri = "qemu+ssh://hero@192.168.165.100/system"
}

module "nodes" {
  source      = "./modules/virt-machine"
  vm_hostname_prefix = "server"
  vm_count    = 3
  memory      = "2048"
  vcpu        = 1
  system_volume = 20
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

```

## License

MIT

## Author Information

Created in 2020 by Michal Muransky
