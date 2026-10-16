#!/usr/bin/env bash
set -euo pipefail

if [[ "${BRANCH_RESULT:-}" != success || "${LAYOUT_RESULT:-}" != success ]]; then
  echo "::error::Branch policy and project layout must both succeed."
  exit 1
fi

case "${BACKEND_ENABLED:-}:${BACKEND_RESULT:-}" in
  true:success|false:skipped) ;;
  *)
    echo "::error::Backend verification did not finish as expected."
    exit 1
    ;;
esac

case "${FRONTEND_ENABLED:-}:${FRONTEND_RESULT:-}" in
  true:success|false:skipped) ;;
  *)
    echo "::error::Frontend build did not finish as expected."
    exit 1
    ;;
esac

echo "All required checks and present modules passed."
if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
  {
    echo "### CI result"
    echo "- Backend: $BACKEND_RESULT (module present: $BACKEND_ENABLED)"
    echo "- Frontend: $FRONTEND_RESULT (module present: $FRONTEND_ENABLED)"
    echo "Skipped absent modules have not been built or tested."
  } >> "$GITHUB_STEP_SUMMARY"
fi
