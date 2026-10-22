# One entry per VM. The groups become Ansible inventory groups.
locals {
  vms = {
    test = {
      cpu    = 1
      vcpu   = 2
      memory = 2048
      groups = ["test"]
    }
  }
}

data "opennebula_template" "debian" {
  name = var.template_name
}

data "opennebula_virtual_network" "default" {
  name = var.network_name
}

resource "opennebula_virtual_machine" "vm" {
  for_each = local.vms

  name        = each.key
  template_id = data.opennebula_template.debian.id
  cpu         = each.value.cpu
  vcpu        = each.value.vcpu
  memory      = each.value.memory

  context = {
    NETWORK        = "YES"
    SET_HOSTNAME   = "$NAME"
    SSH_PUBLIC_KEY = local.ssh_public_keys
  }

  nic {
    network_id = data.opennebula_virtual_network.default.id
  }
}
