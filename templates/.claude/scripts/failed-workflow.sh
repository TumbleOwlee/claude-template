#!/usr/bin/env bash
# Print only the error output of the most recent failed workflow run on the
# current branch. Usage: failed-workflow-error.sh [branch]
set -euo pipefail

branch="${1:-$(git rev-parse --abbrev-ref HEAD)}"

run_id=$(gh run list --branch "$branch" --status failure --limit 1 --json databaseId --jq '.[0].databaseId')
if [ -z "${run_id:-}" ] || [ "$run_id" = "null" ]; then
  echo "No failed run found for branch '$branch'" >&2
  exit 1
fi

job_id=$(gh run view "$run_id" --json jobs --jq '.jobs[] | select(.conclusion=="failure") | .databaseId' | head -n1)
if [ -z "${job_id:-}" ]; then
  echo "Run $run_id failed but no failing job found" >&2
  exit 1
fi

log=$(gh run view "$run_id" --job "$job_id" --log-failed 2>/dev/null || true)
if [ -z "$log" ]; then
  log=$(gh api "repos/{owner}/{repo}/actions/jobs/$job_id/logs")
fi

grep -iE 'error|failed|failure' <<<"$log" | grep -viE '^.*Post job cleanup|deprecated'
