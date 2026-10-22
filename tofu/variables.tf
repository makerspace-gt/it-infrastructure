variable "template_name" {
  description = "Name of the OpenNebula template with Debian 13, for example imported from the marketplace"
  type        = string
  default     = "Debian 13 host-passthrough"
}

variable "network_name" {
  description = "Default OpenNebula virtual network, a VM in vms.tf can choose another one"
  type        = string
}
