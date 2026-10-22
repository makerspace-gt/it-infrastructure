set shell := ["bash", "-euo", "pipefail", "-c"]

# List all recipes
default:
    @just --list

# Create local config files and install Ansible collections
[group('setup')]
setup:
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ ! -f tofu/.env ]]; then cp tofu/.env.example tofu/.env; echo "tofu/.env created, fill in the values from Vaultwarden"; fi
    if [[ ! -f tofu/terraform.tfvars ]]; then cp tofu/terraform.tfvars.example tofu/terraform.tfvars; echo "tofu/terraform.tfvars created, adjust template and network"; fi
    if [[ ! -f ansible/.vault_pass ]]; then echo "ansible/.vault_pass missing, take the password from Vaultwarden"; fi
    ansible-galaxy collection install -r ansible/requirements.yml

# Initialize OpenTofu and download the providers
[group('tofu')]
init:
    cd tofu && source env.sh && tofu init

# Show planned changes after pulling the latest state
[group('tofu')]
plan:
    git pull --ff-only
    cd tofu && source env.sh && tofu plan

# Apply changes, then commit and push state and inventory
[group('tofu')]
[confirm("Apply changes in OpenNebula and push the state?")]
apply:
    git pull --ff-only
    cd tofu && source env.sh && tofu apply
    just state-check
    just state-push "apply tofu"

# Destroy all VMs, then commit and push state and inventory
[group('tofu')]
[confirm("Destroy all VMs in OpenNebula and push the state?")]
destroy:
    git pull --ff-only
    cd tofu && source env.sh && tofu destroy
    just state-check
    just state-push "destroy tofu"

# Show the IP address of every VM
[group('tofu')]
ips:
    cd tofu && source env.sh && tofu output ip_addresses

# Fail if the committed state is not encrypted
[group('tofu')]
state-check:
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ -f tofu/terraform.tfstate ]] && ! grep -q encrypted_data tofu/terraform.tfstate; then
      echo "tofu/terraform.tfstate is not encrypted, do not commit it" >&2
      exit 1
    fi
    echo "State is encrypted"

# Commit and push state, lock file and inventory
[private]
state-push message:
    git add tofu/terraform.tfstate tofu/.terraform.lock.hcl ansible/inventory/hosts.yml
    git diff --cached --quiet || git commit -m "{{ message }}"
    git push

# Show clusters, hosts, networks, datastores, templates and VMs in OpenNebula
[group('opennebula')]
overview *sections:
    python3 scripts/opennebula-overview.py {{ sections }}

# First run of the base role as root, before admin accounts exist
[group('ansible')]
bootstrap limit="all":
    cd ansible && ansible-playbook site.yml -u root --limit {{ limit }}

# Run the playbook with your own admin account
[group('ansible')]
deploy user limit="all":
    cd ansible && ansible-playbook site.yml -u {{ user }} --limit {{ limit }}

# Dry run of the playbook with diff
[group('ansible')]
check user limit="all":
    cd ansible && ansible-playbook site.yml -u {{ user }} --limit {{ limit }} --check --diff

# Format OpenTofu files
[group('lint')]
fmt:
    tofu fmt -recursive tofu

# Check formatting and lint OpenTofu and Ansible
[group('lint')]
lint:
    tofu fmt -check -recursive tofu
    cd tofu && source env.sh && tofu validate
    cd ansible && ansible-lint
