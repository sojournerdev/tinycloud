#!/usr/bin/env bash
set -euo pipefail

cluster_dir="clusters/tinycloud"
schema_config=".fluxschema.yml"

validate_kustomization() {
  local name="$1"
  local path="$2"
  local kustomization_file="$3"

  flux build kustomization "$name" \
    --path "$path" \
    --kustomization-file "$kustomization_file" \
    --dry-run \
    | flux schema validate --config "$schema_config"
}

kustomize build "$cluster_dir" \
  | flux schema validate --config "$schema_config"

validate_kustomization \
  infrastructure \
  "$cluster_dir/infrastructure" \
  "$cluster_dir/infrastructure.yaml"

validate_kustomization \
  platform \
  "$cluster_dir/platform" \
  "$cluster_dir/platform.yaml"
  