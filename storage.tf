resource "libvirt_volume" "base-volume-qcow2" {
  count  = var.base_volume_name != null ? 0 : 1
  name   = format("${var.vm_hostname_prefix}-base.qcow2")
  pool   = var.pool
  source = var.os_img_url
  format = "qcow2"
}

resource "libvirt_volume" "volume-qcow2" {
  count            = var.vm_count
  name             = format("${var.vm_hostname_prefix}%02d.qcow2", count.index + var.index_start)
  pool             = var.pool
  size             = 1024 * 1024 * 1024 * var.system_volume
  base_volume_id   = var.base_volume_name != null ? null : element(libvirt_volume.base-volume-qcow2, 0).id
  base_volume_name = var.base_volume_name
  base_volume_pool = var.base_pool_name

  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count          = var.vm_count
  name           = format("${var.vm_hostname_prefix}_init%02d.iso", count.index + 1)
  user_data      = templatefile(
    "${path.module}/templates/cloud_init.tpl",
    {
      ssh_admin          = var.ssh_admin
      ssh_keys           = local.all_keys
      local_admin        = var.local_admin
      local_admin_passwd = var.local_admin_passwd
      hostname           = format("${var.vm_hostname_prefix}%02d", count.index + var.index_start)
      time_zone          = var.time_zone
      runcmd             = local.runcmd
    }
  )
  network_config = templatefile(
    "${path.module}/templates/network_config_${var.dhcp == true ? "dhcp" : "static"}.tpl",
    {
      ip_address    = element(var.ip_address, count.index)
      ip_gateway    = var.ip_gateway
      ip_nameserver = var.ip_nameserver
      nic           = (var.share_filesystem.source == null ? "ens3" : "ens4")
      # WA: If the shared filesystem is used, Libvirt connects Unclassified device to the 3rd position of PCI bus
    }
  )
  pool           = var.pool
}
