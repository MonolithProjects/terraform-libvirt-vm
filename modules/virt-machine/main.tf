
terraform {
  required_version = ">= 0.13"
    required_providers {
      libvirt = {
        source  = "dmacvicar/libvirt"
        version = "0.6.3"
      }
    }
}

resource "libvirt_domain" "virt-machine" {
  count  = var.vm_count
  name   = format("${var.vm_hostname_prefix}%02d", count.index + 1)
  memory = var.memory
  vcpu   = var.vcpu
  autostart  = true
  qemu_agent = true
  
  cloudinit = element(libvirt_cloudinit_disk.commoninit.*.id, count.index)

  network_interface {
    bridge         = var.bridge
    wait_for_lease = true
    hostname       = format("${var.vm_hostname_prefix}%02d", count.index + 1)
  }

  xml {
    xslt = (var.hugepages == true ? file("${path.module}/xslt/hugepages.xsl") : null)
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = element(libvirt_volume.volume-qcow2.*.id, count.index)
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"Virtual Machine \"$(hostname)\" is UP!\"",
      "date"
    ]

    connection {
      type                = "ssh"
      user                = var.ssh_admin
      host                = self.network_interface.0.addresses.0
      private_key         = file(var.ssh_private_key)
      timeout             = "2m"
    }
  }
}
