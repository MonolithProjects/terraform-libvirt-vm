# Libvirt VM Terraform module

[![GitHub Actions](https://github.com/MonolithProjects/terraform-libvirt-vm/workflows/lint/badge.svg?branch=master)](https://github.com/MonolithProjects/terraform-libvirt-vm/actions)
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
|dhcp|Use DHCP or Static IP settings|false
|ip_address|"List of IP addresses|[ "192.168.123.1" ]
|ssh_keys|List of public ssh keys| []
|admin_passwd|Admin user password|password_example
|ssh_username|User for SSH test|ssh-bot"
|ssh_private_key|Private key for SSH test|~/.ssh/deployer_keys/id_ed25519

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
  uri = "qemu+ssh://hero@192.168.123.100/system"
}

module "k3s_nodes" {
  source      = "./modules/virt-machine"
  vm_count    = 3
  memory      = "2048"
  vcpu        = 1
  dhcp        = false
  os_img_url  = "file:///home/myuser/ubuntu-20.04-server-cloudimg-amd64.img"
  ip_address  = [ 
                  "192.168.123.101",
                  "192.168.123.102",
                  "192.168.123.103" 
                ]
  admin_passwd = "$6$rounds=4-XXXXXXXXXXXXXXXXX-HASHED-PASSWORD"
  ssh_keys    = [ "ssh-ed25519 XXXXXXXXXXXXXXXXX example", ]
}

```

## License

MIT

## Author Information

Created in 2020 by Michal Muransky
