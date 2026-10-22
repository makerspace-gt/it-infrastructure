#!/usr/bin/env bash
set -euo pipefail

# OpenTofu from the official Debian repository
curl -fsSL https://get.opentofu.org/install-opentofu.sh -o /tmp/install-opentofu.sh
sudo bash /tmp/install-opentofu.sh --install-method deb
rm /tmp/install-opentofu.sh

# just for the recipes in the Justfile
sudo apt-get update
sudo apt-get install -y --no-install-recommends just

# Ansible and linting
pip install --no-cache-dir ansible ansible-lint

# Collections used by the roles
ansible-galaxy collection install -r ansible/requirements.yml
