output "name" {
  value = libvirt_domain.virt-machine.*.name
}
output "ip_address" {
  value = libvirt_domain.virt-machine.*.network_interface.0.addresses.0
}