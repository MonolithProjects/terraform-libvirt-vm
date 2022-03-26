data "template_file" "network_config" {
  count    = var.vm_count
  template = file("${path.module}/templates/network_config_${var.dhcp == true ? "dhcp" : "static"}.tpl")
  vars = {
    ip_address    = element(var.ip_address, count.index)
    ip_gateway    = var.ip_gateway
    ip_nameserver = var.ip_nameserver
    nic           = (var.share_filesystem.source == null ? "ens3" : "ens4")
    # WA: If the shared filesystem is used, Libvirt connects Unclassified device to the 3rd position of PCI bus
  }
}

data "template_file" "init_config" {
  count    = var.vm_count
  template = file("${path.module}/templates/cloud_init.tpl")
  vars = {
    ssh_admin          = var.ssh_admin
    ssh_keys           = local.all_keys
    local_admin        = var.local_admin
    local_admin_passwd = var.local_admin_passwd
    hostname           = format("${var.vm_hostname_prefix}%02d", count.index + var.index_start)
    time_zone          = var.time_zone
  }
}

locals {
  all_keys = <<EOT
[
%{~for keys in var.ssh_keys~}
"${keys}",
%{~endfor~}
]
EOT
}

data "template_cloudinit_config" "init_config" {
  count         = var.vm_count
  gzip          = false
  base64_encode = false

  part {
    filename     = format("init%02d.cfg", count.index + var.index_start)
    content_type = "text/cloud-config"
    content      = data.template_file.init_config[count.index].rendered
  }
}
