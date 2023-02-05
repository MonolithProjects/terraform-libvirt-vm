# Libvirt VM Terraform module

[![GitHub Actions](https://github.com/MonolithProjects/terraform-libvirt-vm/workflows/Lint/badge.svg)](https://github.com/MonolithProjects/terraform-libvirt-vm/actions)
[![License](https://img.shields.io/github/license/MonolithProjects/terraform-libvirt-vm)](https://github.com/MonolithProjects/terraform-libvirt-vm/blob/master/LICENSE)
[![Terraform](https://badgen.net/badge/Terraform%20Registry/yes/blue?icon=terraform)](https://registry.terraform.io/modules/MonolithProjects/vm/libvirt/latest)

Terraform module for KVM/Libvirt Virtual Machine. This module will create a KVM Virtual Machine(s), configure it using Cloud Init and test the ssh connection. This module is using [dmacvicar/libvirt](https://github.com/dmacvicar/terraform-provider-libvirt) Terraform provider.

## What it provides

- creates one or more VMs
- one NIC per domain, connected to the network using the **bridge interface**
- setup network interface using DHCP or static configuration
- cloud_init VM(s) configuration (Ubuntu+Netplan complient)
- optionally add multiple extra disks
- test the ssh connection

## Tested on

- Ubuntu 20.04 TLS Cloud Image
- Ubuntu 22.04 TLS Cloud Image

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | >=0.6.9 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [libvirt_cloudinit_disk.commoninit](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit_disk) | resource |
| [libvirt_domain.virt-machine](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain) | resource |
| [libvirt_volume.base-volume-qcow2](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [libvirt_volume.volume-qcow2](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_disk_ids"></a> [additional\_disk\_ids](#input\_additional\_disk\_ids) | List of volume ids | `list(string)` | `[]` | no |
| <a name="input_autostart"></a> [autostart](#input\_autostart) | Autostart the domain | `bool` | `true` | no |
| <a name="input_base_pool_name"></a> [base\_pool\_name](#input\_base\_pool\_name) | Name of base OS image | `string` | `null` | no |
| <a name="input_base_volume_name"></a> [base\_volume\_name](#input\_base\_volume\_name) | Name of base OS image | `string` | `null` | no |
| <a name="input_bridge"></a> [bridge](#input\_bridge) | Bridge interface | `string` | `"virbr0"` | no |
| <a name="input_cpu_mode"></a> [cpu\_mode](#input\_cpu\_mode) | CPU mode | `string` | `"host-passthrough"` | no |
| <a name="input_dhcp"></a> [dhcp](#input\_dhcp) | Use DHCP or Static IP settings | `bool` | `false` | no |
| <a name="input_index_start"></a> [index\_start](#input\_index\_start) | From where the indexig start | `number` | `1` | no |
| <a name="input_ip_address"></a> [ip\_address](#input\_ip\_address) | List of IP addresses | `list(string)` | <pre>[<br>  "192.168.123.101"<br>]</pre> | no |
| <a name="input_ip_gateway"></a> [ip\_gateway](#input\_ip\_gateway) | IP addresses of a gateway | `string` | `"192.168.123.1"` | no |
| <a name="input_ip_nameserver"></a> [ip\_nameserver](#input\_ip\_nameserver) | IP addresses of a nameserver | `string` | `"192.168.123.1"` | no |
| <a name="input_local_admin"></a> [local\_admin](#input\_local\_admin) | Admin user without ssh access | `string` | `""` | no |
| <a name="input_local_admin_passwd"></a> [local\_admin\_passwd](#input\_local\_admin\_passwd) | Local admin user password | `string` | `"password_example"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | RAM in MB | `string` | `"1024"` | no |
| <a name="input_os_img_url"></a> [os\_img\_url](#input\_os\_img\_url) | URL to the OS image | `string` | `"https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"` | no |
| <a name="input_pool"></a> [pool](#input\_pool) | Storage pool name | `string` | `"default"` | no |
| <a name="input_runcmd"></a> [runcmd](#input\_runcmd) | Extra commands to be run with cloud init | `list(string)` | <pre>[<br>  "[ systemctl, daemon-reload ]",<br>  "[ systemctl, enable, qemu-guest-agent ]",<br>  "[ systemctl, start, qemu-guest-agent ]",<br>  "[ systemctl, restart, systemd-networkd ]"<br>]</pre> | no |
| <a name="input_share_filesystem"></a> [share\_filesystem](#input\_share\_filesystem) | n/a | <pre>object({<br>    source   = string<br>    target   = string<br>    readonly = bool<br>    mode     = string<br>  })</pre> | <pre>{<br>  "mode": null,<br>  "readonly": false,<br>  "source": null,<br>  "target": null<br>}</pre> | no |
| <a name="input_ssh_admin"></a> [ssh\_admin](#input\_ssh\_admin) | Admin user with ssh access | `string` | `"ssh-admin"` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | List of public ssh keys | `list(string)` | `[]` | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | Private key for SSH connection test | `string` | `null` | no |
| <a name="input_system_volume"></a> [system\_volume](#input\_system\_volume) | System Volume size (GB) | `number` | `10` | no |
| <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone) | Time Zone | `string` | `"UTC"` | no |
| <a name="input_vcpu"></a> [vcpu](#input\_vcpu) | Number of vCPUs | `number` | `1` | no |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | Number of VMs | `number` | `1` | no |
| <a name="input_vm_hostname_prefix"></a> [vm\_hostname\_prefix](#input\_vm\_hostname\_prefix) | VM hostname prefix | `string` | `"vm"` | no |
| <a name="input_xml_override"></a> [xml\_override](#input\_xml\_override) | With these variables you can: Enable hugepages; Set USB controllers; Attach USB devices | <pre>object({<br>    hugepages = bool<br>    usb_controllers = list(object({<br>      model = string<br>    }))<br>    usb_devices = list(object({<br>      vendor  = string<br>      product = string<br>    }))<br>  })</pre> | <pre>{<br>  "hugepages": false,<br>  "usb_controllers": [<br>    {<br>      "model": "piix3-uhci"<br>    }<br>  ],<br>  "usb_devices": []<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Example

Example with enable HugePages, Attached USB device, changed USB controller model... :

```hcl
terraform {
  required_version = ">= 0.13"
    required_providers {
      libvirt = {
        source  = "dmacvicar/libvirt"
      }
    }
}

provider "libvirt" {
  uri = "qemu+ssh://hero@192.168.165.100/system"
}

module "vm" {
  source  = "MonolithProjects/vm/libvirt"
  version = "1.8.0"

  vm_hostname_prefix = "server"
  vm_count    = 3
  memory      = "2048"
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
  xml_override = {
      hugepages = true,
      usb_controllers = [
        {
          model = "qemu-xhci"
        }
      ],
      usb_devices = [
        {
          vendor = "0x0bc2",
          product = "0xab28"
        }
      ]
    }
}

output "ip_addresses" {
  value = module.nodes
}
```

Static IP settings... :

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
  version = "1.8.0"

  vm_hostname_prefix = "server"
  vm_count    = 3
  memory      = "2048"
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

> The shared directory from the example can be mounted inside the VM with command `sudo mount -t 9p -o trans=virtio,version=9p2000.L,rw tmp /host/tmp`

Create a VM with an extra disk

```
# Creates a 50GB extra-data-disk within vms pool
resource "libvirt_volume" "data_volume" {
  pool = "vms"
  name  = "extra-data-disk.qcow2"
  format = "qcow2"
  size = 1024*1024*1024*50
}

module "vm" {
  source  = "MonolithProjects/vm/libvirt"
  version = "1.8.0"

  vm_hostname_prefix = "data-server"
  base_volume_name = "debian-11-base.qcow2"
  base_pool_name = "linked-images"
  vm_count    = 1
  bridge =        "bridge-dmz"
  memory      = "4096"
  vcpu        = 4
  pool        = "vms"
  system_volume = 25
  additional_disk_ids = [ libvirt_volume.data_volume.id ]
  dhcp        = true
  ssh_admin   = "admin"
  ssh_keys    = [
    chomp(file("~/.ssh/id_rsa.pub"))
    ]
  time_zone   = "America/Argentina/Buenos_Aires"
}

output "ip_addresses" {
  value = module.vm
}
```

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
