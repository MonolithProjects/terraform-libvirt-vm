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
