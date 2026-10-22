# One entry per VM. The groups become Ansible inventory groups.
# Every VM sets all fields so that OpenTofu sees a uniform map.
# location = null uses var.default_location, the locations are defined in terraform.tfvars.
locals {
  vms = {
    test = {
      cpu      = 1
      vcpu     = 2
      memory   = 2048
      groups   = ["test"]
      location = null
    }
  }

  vm_locations = { for name, vm in local.vms : name => var.locations[coalesce(vm.location, var.default_location)] }
}

data "opennebula_template" "debian" {
  name = var.template_name
}

data "opennebula_virtual_network" "network" {
  for_each = toset([for location in values(local.vm_locations) : location.network])
  name     = each.key
}

resource "opennebula_virtual_machine" "vm" {
  for_each = local.vms

  name        = each.key
  template_id = data.opennebula_template.debian.id
  cpu         = each.value.cpu
  vcpu        = each.value.vcpu
  memory      = each.value.memory

  # Only the hosts of the location are allowed
  sched_requirements = join(" | ", [for host in local.vm_locations[each.key].hosts : "HOSTNAME = \"${host}\""])

  context = {
    NETWORK        = "YES"
    SET_HOSTNAME   = "$NAME"
    SSH_PUBLIC_KEY = local.ssh_public_keys
  }

  nic {
    network_id = data.opennebula_virtual_network.network[local.vm_locations[each.key].network].id
  }
}
