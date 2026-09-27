#!/usr/bin/env bash
set -euo pipefail

if ! command -v mise >/dev/null 2>&1; then
  brew install mise
fi

mise --version
