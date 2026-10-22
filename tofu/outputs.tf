output "ip_addresses" {
  description = "IPv4 address of every VM"
  value       = { for name, vm in opennebula_virtual_machine.vm : name => vm.nic[0].computed_ip }
}
