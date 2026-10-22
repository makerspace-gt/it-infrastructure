# One entry per VM. The groups become Ansible inventory groups.
# network is optional and defaults to var.network_name.
# sched_requirements is optional and pins the VM to hosts or clusters,
# for example "CLUSTER_ID = 100" or "HOSTNAME = \"host1\"".
locals {
  vms = {
    test = {
      cpu    = 1
      vcpu   = 2
      memory = 2048
      groups = ["test"]
    }
  }

  vm_networks = { for name, vm in local.vms : name => try(vm.network, var.network_name) }
}

data "opennebula_template" "debian" {
  name = var.template_name
}

data "opennebula_virtual_network" "network" {
  for_each = toset(values(local.vm_networks))
  name     = each.key
}

resource "opennebula_virtual_machine" "vm" {
  for_each = local.vms

  name               = each.key
  template_id        = data.opennebula_template.debian.id
  cpu                = each.value.cpu
  vcpu               = each.value.vcpu
  memory             = each.value.memory
  sched_requirements = try(each.value.sched_requirements, null)

  context = {
    NETWORK        = "YES"
    SET_HOSTNAME   = "$NAME"
    SSH_PUBLIC_KEY = local.ssh_public_keys
  }

  nic {
    network_id = data.opennebula_virtual_network.network[local.vm_networks[each.key]].id
  }
}
