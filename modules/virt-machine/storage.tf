resource "libvirt_pool" "terra" {
  name = "terratest"
  type = "dir"
  path = var.libvirt_disk_path
}

resource "libvirt_volume" "base-volume-qcow2" {
  name   = format("${var.vm_hostname_prefix}-base.qcow2")
  pool   = libvirt_pool.terra.name
  source = var.os_img_url
  format = "qcow2"
}

resource "libvirt_volume" "volume-qcow2" {
  count  = var.vm_count
  name   = format("${var.vm_hostname_prefix}%02d.qcow2", count.index + 1)
  pool   = libvirt_pool.terra.name
  size   = 1024*1024*1024*var.system_volume
  base_volume_id = libvirt_volume.base-volume-qcow2.id
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count          = var.vm_count
  name           = format("${var.vm_hostname_prefix}_init%2d.iso", count.index + 1)
  user_data      = data.template_cloudinit_config.init_config[count.index].rendered
  network_config = data.template_file.network_config[count.index].rendered
  pool           = libvirt_pool.terra.name
}