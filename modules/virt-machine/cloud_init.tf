data "template_file" "network_config" {
  count = var.vm_count
  template = file("${path.module}/templates/network_config_${var.dhcp == true ? "dhcp" : "static"}.tpl")
  vars = {
    ip_address = element(var.ip_address, count.index)
  }
}

data "template_file" "init_config" {
  count = var.vm_count
  template = file("${path.module}/templates/cloud_init.tpl")
  vars = {
    ssh_keys = local.all_keys
    admin_passwd = var.admin_passwd
    hostname = format("${var.vm_hostname_prefix}_%02d", count.index + 1)
  }
}

locals {
  all_keys = <<EOT
[
%{~ for keys in var.ssh_keys ~}
"${keys}",
%{~ endfor ~}
]
EOT
}

data "template_cloudinit_config" "init_config" {
  count         = var.vm_count
  gzip          = false
  base64_encode = false

  part {
    filename     = format("init_%02d.cfg", count.index + 1)
    content_type = "text/cloud-config"
    content      = data.template_file.init_config[count.index].rendered
  }
}