locals {
  all_keys = <<EOT
[
%{~for keys in var.ssh_keys~}
"${keys}",
%{~endfor~}
]
EOT
  runcmd   = <<EOT
%{for cmd in var.runcmd~}
  - ${cmd}
%{endfor~}
EOT
}

data "cloudinit_config" "init_config" {
  count         = var.vm_count
  gzip          = false
  base64_encode = false

  part {
    filename     = format("init%02d.cfg", count.index + var.index_start)
    content_type = "text/cloud-config"
    content      = templatefile(
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
  }
}
