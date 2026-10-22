#!/usr/bin/env bash
# Load credentials from tofu/.env and configure state encryption.
# Usage from the tofu directory: source env.sh

env_file="$(dirname "${BASH_SOURCE[0]}")/.env"
if [[ ! -f "$env_file" ]]; then
  echo "Missing $env_file, copy .env.example and fill in the values" >&2
  return 1
fi

set -a
# shellcheck source=/dev/null
source "$env_file"
set +a

if [[ ${#TOFU_STATE_PASSPHRASE} -lt 16 ]]; then
  echo "TOFU_STATE_PASSPHRASE must have at least 16 characters" >&2
  return 1
fi

# Do not rename pbkdf2.main or aes_gcm.main, the encrypted state refers to these names
export TF_ENCRYPTION=$(cat <<EOT
key_provider "pbkdf2" "main" {
  passphrase = "${TOFU_STATE_PASSPHRASE}"
}
method "aes_gcm" "main" {
  keys = key_provider.pbkdf2.main
}
state {
  method = method.aes_gcm.main
}
plan {
  method = method.aes_gcm.main
}
EOT
)

echo "OpenTofu credentials and state encryption loaded"
