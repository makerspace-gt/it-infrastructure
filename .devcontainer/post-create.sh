#!/usr/bin/env bash
set -euo pipefail

# OpenTofu from the official Debian repository
curl -fsSL https://get.opentofu.org/install-opentofu.sh -o /tmp/install-opentofu.sh
sudo bash /tmp/install-opentofu.sh --install-method deb
rm /tmp/install-opentofu.sh

# Ansible and linting
pip install --no-cache-dir ansible ansible-lint

# Collections used by the roles
ansible-galaxy collection install -r ansible/requirements.yml
