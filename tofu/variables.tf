variable "template_name" {
  description = "Name of the OpenNebula template with Debian 13, for example imported from the marketplace"
  type        = string
  default     = "Debian 13"
}

variable "network_name" {
  description = "Name of the OpenNebula virtual network for the VMs"
  type        = string
}
