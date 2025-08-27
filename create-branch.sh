#!/bin/bash

# Allowed types
ALLOWED_TYPES="feature|bugfix|hotfix|release|docs|build|test|refactor|chore"

# Check if a branch name was provided
if [ -z "$1" ]; then
  echo "❌ Please provide a branch name."
  echo "Usage: ./create-branch.sh {branch-name}"
  exit 1
fi

branch_name=$1

# Regex pattern
pattern="^(${ALLOWED_TYPES})(/(issue|ticket)/[A-Za-z0-9_-]+)?/[a-z0-9-]+$"

# Check against pattern
if [[ $branch_name =~ $pattern ]]; then
  git checkout -b "$branch_name"
  echo "✅ Branch '$branch_name' created."
  git push -u origin "$branch_name"
  echo "✅ Branch '$branch_name' pushed to remote."
else
  echo "❌ Branch name '$branch_name' does not follow naming convention."
  echo "✅ Format: {type}[/issue/{number} | /ticket/{id}]/{short-description}"
  echo "📌 Allowed types: $ALLOWED_TYPES"
  exit 1
fi
