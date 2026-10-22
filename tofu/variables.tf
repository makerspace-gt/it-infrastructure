variable "template_name" {
  description = "Name of the OpenNebula template with Debian 13, for example imported from the marketplace"
  type        = string
  default     = "Debian 13 host-passthrough"
}

variable "image_name" {
  description = "Name of the Debian 13 disk image used by the template, it is resized per VM"
  type        = string
  default     = "Debian 13"
}

variable "locations" {
  description = "A cluster or a set of hosts and the network they share. VMs refer to a location by its key."
  type = map(object({
    cluster_id = optional(number)
    hosts      = optional(list(string), [])
    network    = string
  }))
}

variable "default_location" {
  description = "Location for VMs that do not choose one"
  type        = string
}
