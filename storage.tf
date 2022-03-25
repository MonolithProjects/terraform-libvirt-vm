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
  name           = format("${var.vm_hostname_prefix}_init%2d.iso", count.index + 1)
  user_data      = data.template_cloudinit_config.init_config[count.index].rendered
  network_config = data.template_file.network_config[count.index].rendered
  pool           = var.pool
}
