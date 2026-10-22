terraform {
  required_version = ">= 1.10"

  required_providers {
    opennebula = {
      source  = "OpenNebula/opennebula"
      version = "~> 1.5"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # The key provider and method come from TF_ENCRYPTION, see README.md.
  # These blocks refuse to write unencrypted state or plans.
  encryption {
    state {
      enforced = true
    }
    plan {
      enforced = true
    }
  }
}
