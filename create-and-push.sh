#!/bin/bash

# Script to create GitHub repository and push code
# Usage: 
#   GITHUB_TOKEN=your_token ./create-and-push.sh
#   OR
#   ./create-and-push.sh your_token

set -e

REPO_NAME="ingrid-v3"
USERNAME="tedotedo"
DESCRIPTION="Portfolio website for Ingrid Aszkenasy - Contemporary textile art portfolio"

# Get token from command line argument or environment variable
if [ -n "$1" ]; then
    GITHUB_TOKEN="$1"
elif [ -z "$GITHUB_TOKEN" ]; then
    echo "Creating GitHub repository: $REPO_NAME"
    echo "Please enter your GitHub personal access token:"
    read -s GITHUB_TOKEN
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GitHub token is required"
    echo "Usage: GITHUB_TOKEN=your_token ./create-and-push.sh"
    echo "   OR: ./create-and-push.sh your_token"
    exit 1
fi

# Create repository via GitHub API
echo "Creating repository on GitHub..."
RESPONSE=$(curl -s -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $GITHUB_TOKEN" \
    https://api.github.com/user/repos \
    -d "{\"name\":\"$REPO_NAME\",\"description\":\"$DESCRIPTION\",\"private\":false}")

# Check if repository was created successfully
if echo "$RESPONSE" | grep -q '"name"'; then
    echo "✓ Repository created successfully!"
else
    echo "Error creating repository:"
    echo "$RESPONSE"
    exit 1
fi

# Push code to GitHub
echo "Pushing code to GitHub..."
git push -u origin main

echo ""
echo "✓ Success! Your repository is available at:"
echo "  https://github.com/$USERNAME/$REPO_NAME"

