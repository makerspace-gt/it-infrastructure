variable "template_name" {
  description = "Name of the OpenNebula template with Debian 13, for example imported from the marketplace"
  type        = string
  default     = "Debian 13 host-passthrough"
}

variable "locations" {
  description = "Hosts that belong together and the network they share. VMs refer to a location by its key."
  type = map(object({
    hosts   = list(string)
    network = string
  }))
}

variable "default_location" {
  description = "Location for VMs that do not choose one"
  type        = string
}
