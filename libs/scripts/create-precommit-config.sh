#!/usr/bin/env bash

set -euo pipefail

CONFIG_FILE=".pre-commit-config.yaml"

create_config() {
    local config_content
    config_content=$(cat << 'EOF'
default_stages: [pre-commit, pre-push]
default_install_hook_types: [pre-commit, pre-push]

repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.1
    hooks:
      - id: gitleaks

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.3.0
    hooks:
      - id: check-yaml
      - id: check-json
      - id: check-added-large-files
      - id: trailing-whitespace
      - id: end-of-file-fixer
        exclude: '\.json$'
      - id: check-merge-conflict
        args: [--assume-in-merge]

  - repo: local
    hooks:
      - id: nix-fmt
        name: nix-fmt
        language: system
        entry: nix fmt

EOF
)
    echo "${config_content}" > "${CONFIG_FILE}"
}

main() {
    if [[ ! -f "${CONFIG_FILE}" ]]; then
        echo "Creating ${CONFIG_FILE} with default configuration..."
        create_config
        echo "${CONFIG_FILE} created successfully."
    else
        echo "${CONFIG_FILE} already exists. Skipping creation."
    fi
}

main "$@"
