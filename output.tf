output "masters-ips" {
  value = libvirt_domain.domain-ubuntu-master.*.network_interface.0.addresses
}

output "workers-ips" {
  value = libvirt_domain.domain-ubuntu-worker.*.network_interface.0.addresses
}