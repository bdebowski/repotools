#!/bin/bash
#
# Removes the git repo specified from github and optionally removes all local files/folders for the repo as well.

REPOS_DIR="$HOME/dev/repos"

# Display usage info
usage() {
    echo "Usage: $0 <repo_name> [-a]"
    echo "  <repo_name>  Name of repo to remove."
    echo "  -a           Remove local files/directories for the repo as well."
    exit 1
}
warn() {
	echo "WARNING: This will remove the projet $REPO_NAME from your GitHub repos."
    if $REM_ALL; then
	    echo "WARNING: This will also completely remove $REPO_DIR and all contained files from your machine."
}

# Parse input
if [ -z "$1" ]; then
	usage
fi
REPO_NAME="$1"
REPO_DIR="$REPOS_DIR/$REPO_NAME"
REM_ALL=false

# Parse optional flags
shift  # Shift positional argument off so getopts processes only flags
while getopts "a" opt; do
    case "$opt" in
	    a) REM_ALL=true ;;
        *) usage ;;
    esac
done

# Confirm with the user before proceeding
warn
read -p "Are you sure you want to continue? (yes/no): " CONFIRMATION

if [[ "$CONFIRMATION" != "yes" ]]; then
    echo "Operation cancelled."
    exit 1
fi

# Delete GitHub repository
gh auth refresh -h github.com -s delete_repo
gh repo delete "$REPO_NAME" --yes
echo "Deleted GitHub repository: $REPO_NAME"

# Remove all files for the repo from the machine
if REM_ALL; then
    rm -rf "$REPO_DIR"
    echo "Deleted repo directory: $REPO_DIR"
	
echo "DONE"