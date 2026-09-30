#!/usr/bin/env bash
set -euo pipefail

cluster_name="${CLUSTER_NAME:-kind-tinycloud-ci}"
manifest_file="$(mktemp)"

cleanup() {
  rm -f "$manifest_file"
  ctlptl delete cluster "$cluster_name" >/dev/null 2>&1 || true
}

trap cleanup EXIT INT TERM

ctlptl delete cluster "$cluster_name" >/dev/null 2>&1 || true
ctlptl create cluster kind --name="$cluster_name"

kustomize build clusters/tinycloud >"$manifest_file"

yq 'select(.kind == "CustomResourceDefinition")' "$manifest_file" \
  | kubectl apply --server-side --field-manager=ci -f -

while IFS= read -r namespace; do
  kubectl create namespace "$namespace" \
    --dry-run=client \
    -o yaml \
    | kubectl apply --server-side --field-manager=ci -f -
done < <(yq -r 'select(.kind == "Namespace") | .metadata.name' "$manifest_file")

kubectl wait --for=condition=Established crd --all --timeout=120s
kubectl apply \
  --server-side \
  --dry-run=server \
  --validate=strict \
  --field-manager=ci \
  -f "$manifest_file"
