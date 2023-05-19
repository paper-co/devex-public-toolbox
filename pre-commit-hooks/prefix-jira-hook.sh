#!/bin/bash
# The script below adds the branch name automatically to
# every one of your commit messages. The regular expression
# below searches for JIRA issue key's. The issue key will
# be extracted out of your branch name

if [ -z "$1" ]; then
  echo
  echo "Usage: $0 <file-path>"
  exit 1
fi

REGEX_ISSUE_ID="[a-zA-Z0-9,\.\_\-]+-[0-9]+"

# Find current branch name
BRANCH_NAME=${BRANCH_NAME:-$(git symbolic-ref --short HEAD)}

if [[ -z "$BRANCH_NAME" ]]; then
    echo "No branch name"
    exit 1
fi

# Extract issue id from branch name
ISSUE_ID=$(echo "$BRANCH_NAME" | grep -o -E "$REGEX_ISSUE_ID")

if [ -z "$ISSUE_ID" ]; then
    echo "No issue detected"
    exit 0
fi

PREFIX="$ISSUE_ID: "

# Check if message already has issue prefix

PREFIX_IN_COMMIT=$(grep -c "^$PREFIX" $1)

if [[ $PREFIX_IN_COMMIT -ge 1 ]]; then
  echo "Message already prefixed"
  exit 0
fi

MESSAGE="$ISSUE_ID: $(cat $1)"

if [ -z "$DEBUG" ]; then
  echo "$MESSAGE" > "$1"
else
  echo "$MESSAGE"
fi
