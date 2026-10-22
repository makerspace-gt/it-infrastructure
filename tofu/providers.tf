# Credentials come from OPENNEBULA_ENDPOINT, OPENNEBULA_USERNAME and OPENNEBULA_PASSWORD
provider "opennebula" {
  default_tags {
    tags = {
      managed_by = "opentofu"
      repo       = "it-infrastructure"
    }
  }
}
