#!/bin/bash

# Ensure an environment name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <env_name>"
    exit 1
fi

ENV_NAME="$1"

# Check that this python environment exists
if ! conda env list | grep -qE "^$ENV_NAME[[:space:]]"; then
    echo "Could not find conda environment named $ENV_NAME."
	echo "Exiting"
	exit 1
fi

# Confirm with the user before proceeding
echo "WARNING: This will completely remove the conda environment $ENV_NAME."
read -p "Are you sure you want to continue? (yes/no): " CONFIRMATION

if [[ "$CONFIRMATION" != "yes" ]]; then
    echo "Operation cancelled."
    exit 1
fi

# Remove Conda environment
conda remove --name "$ENV_NAME" --all -y

echo "DONE"