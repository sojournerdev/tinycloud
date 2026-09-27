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

validate_helm_chart() {
  local release_name="$1"
  local chart="$2"
  local version="$3"
  local namespace="$4"
  shift 4

  helm template "$release_name" "$chart" \
    --version "$version" \
    --namespace "$namespace" \
    "$@" \
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


validate_helm_chart \
  semantic-router \
  oci://ghcr.io/vllm-project/charts/semantic-router \
  0.3.0 \
  semantic-router

validate_helm_chart \
  vllm \
  vllm-stack \
  0.1.12 \
  vllm \
  --repo https://vllm-project.github.io/production-stack

validate_helm_chart \
  metallb \
  metallb \
  0.16.1 \
  metallb-system \
  --repo https://metallb.github.io/metallb

validate_helm_chart \
  nvidia-device-plugin \
  nvidia-device-plugin \
  0.20.0 \
  nvidia-device-plugin \
  --repo https://nvidia.github.io/k8s-device-plugin

validate_helm_chart \
  prometheus \
  kube-prometheus-stack \
  91.5.0 \
  prometheus \
  --repo https://prometheus-community.github.io/helm-charts

validate_helm_chart \
  envoy-gateway \
  oci://docker.io/envoyproxy/gateway-helm \
  v1.9.1 \
  envoy-gateway-system
