#!/usr/bin/env bash
# Print an issue's title, body, and comments in a compact plain-text form —
# cheaper to read than `gh issue view --comments`'s formatted output.
# Usage: issue-view.sh <number|url>
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: issue-view.sh <number|url>" >&2
  exit 1
fi

gh issue view "$1" --json number,title,state,url,author,body,comments --jq '
  "#\(.number) \(.title) [\(.state)]",
  .url,
  "by \(.author.login)",
  "",
  (.body // "(no body)"),
  "",
  "--- \(.comments | length) comment(s) ---",
  (.comments[] | "", "[\(.author.login) @ \(.createdAt)]", (.body // "(empty)"))
'
