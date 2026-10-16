#!/usr/bin/env bash
set -euo pipefail

backend=false
frontend=false

if [[ -f backend/pom.xml ]]; then
  backend=true
elif [[ -d backend/src ]]; then
  echo "::error::backend/src exists but backend/pom.xml is missing."
  exit 1
fi

if [[ -f frontend/package.json ]]; then
  if [[ ! -f frontend/package-lock.json ]]; then
    echo "::error::Commit frontend/package-lock.json so CI can run npm ci."
    exit 1
  fi
  frontend=true
elif [[ -d frontend/src || -f frontend/package-lock.json ]]; then
  echo "::error::Frontend source or lockfile exists but frontend/package.json is missing."
  exit 1
fi

{
  printf 'backend=%s\n' "$backend"
  printf 'frontend=%s\n' "$frontend"
} >> "${GITHUB_OUTPUT:-/dev/stdout}"

echo "Detected modules: backend=$backend, frontend=$frontend"
if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
  {
    echo "### Module detection"
    echo "- Backend Maven module: $backend"
    echo "- Frontend npm module: $frontend"
    echo "Absent modules are skipped; no application build is claimed for them."
  } >> "$GITHUB_STEP_SUMMARY"
fi
