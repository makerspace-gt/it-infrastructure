terraform {
  required_version = ">= 1.10"

  required_providers {
    # 1.4.0 is the last release that supports OpenNebula 5.12, which we still run.
    # Raise the version after upgrading OpenNebula.
    opennebula = {
      source  = "OpenNebula/opennebula"
      version = "= 1.4.0"
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
