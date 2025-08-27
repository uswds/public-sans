#!/bin/bash

# Ensure API key is set
if [ -z "$OPENAI_API_KEY" ]; then
  echo "❌ Please set your OPENAI_API_KEY environment variable."
  exit 1
fi

# Set model and endpoint
MODEL="gpt-4"
ENDPOINT="https://api.openai.com/v1/chat/completions"

# Get current branch and base branch
branch=$(git rev-parse --abbrev-ref HEAD)
default_branch=$(git remote show origin | grep 'HEAD branch' | awk '{print $NF}')

# Extract commits from current branch
commits=$(git log "$default_branch"..HEAD --pretty=format:"%s" | grep -E "^(feat|fix|docs|style|refactor|test|chore|build|ci|perf)(\(.*\))?: ")

if [ -z "$commits" ]; then
  echo "❌ No Conventional Commits found on this branch."
  exit 1
fi

# Prepare JSON payload with Conventional Commit title prompt
messages=$(jq -n \
  --arg commits "$commits" \
  '[
    {
      "role": "system",
      "content": "You are an assistant that writes pull request titles in the Conventional Commits format (https://www.conventionalcommits.org/en/v1.0.0/)."
    },
    {
      "role": "user",
      "content": "Here are the commit messages:\n\n\($commits)\n\nWrite a concise PR title that summarizes the changes and follows the Conventional Commits format. Use an appropriate type (e.g., feat, fix, chore) and include a scope in parentheses if applicable. Return only the title and nothing else."
    }
  ]'
)

# Call OpenAI API
response=$(curl -s "$ENDPOINT" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"model\": \"$MODEL\", \"messages\": $messages, \"temperature\": 0.4}"
)

# Extract and display title
title=$(echo "$response" | jq -r '.choices[0].message.content' | head -n 1)

echo ""
echo "✅ Suggested PR title from OpenAI:"
echo "$title"
echo ""

# Optionally prompt to confirm and create PR
read -p "📝 Use this title to create the PR? [y/N]: " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  gh pr create --title "$title" --body "" --head "$branch"
else
  echo "🛑 PR not created. You can still copy and use the title manually."
fi
