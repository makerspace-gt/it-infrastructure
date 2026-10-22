# The admin list is shared with Ansible, so access is defined in one place only
locals {
  admins = [
    for admin in yamldecode(file("${path.module}/../ansible/group_vars/all/admins.yml")).admins :
    admin if try(admin.state, "present") == "present"
  ]
}

data "http" "ssh_keys" {
  for_each = { for admin in local.admins : admin.github => admin }
  url      = "https://github.com/${each.key}.keys"
}

locals {
  ssh_public_keys = join("\n", flatten([
    for response in data.http.ssh_keys : compact(split("\n", response.response_body))
  ]))
}
