provider "libvirt" {
  uri = "qemu:///system"
}

module "test_nodes" {
  source             = "../../"
  vm_hostname_prefix = "test"
  autostart          = false
  vm_count           = 2
  index_start        = 1
  memory             = "512"
  vcpu               = 1
  system_volume      = 20
  ssh_admin          = "admin"
  ssh_private_key    = "~/.ssh/your_key_id_ed25519"
  ssh_keys = [
    "ssh-ed25519 somethingSOMETHING your_key",
  ]
  local_admin        = "localadmin"
  local_admin_passwd = "<yout password hash (mkpasswd --method=SHA-512 --rounds=4096)>"
}

output "output_data" {
  value = module.test_nodes
}
