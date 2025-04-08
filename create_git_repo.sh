#!/bin/bash

# Ensure a project name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

PROJECT_NAME="$1"
PROJECT_DIR="$HOME/dev/repos/$PROJECT_NAME"

# Check that name is available in repos
if [ -e "$PROJECT_DIR" ]; then
    echo "Cannot create repo '$PROJECT_NAME'."
    echo "A repo with that name already exists."
    exit 1
fi

# Create project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit 1

# Create and initialize the git repo
git init
git branch -m master
gh repo create "$PROJECT_NAME" --private --source=. --remote=origin
echo "\# $PROJECT_NAME" > README.md
touch .gitignore
git add README.md
git add .gitignore
git commit -m "Inception"
git push -u origin master

echo "Project repo $PROJECT_NAME created successfully."
