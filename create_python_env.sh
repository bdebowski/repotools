#!/bin/bash
#
# Initializes a Python Environment in the target git repo specified using conda.
# Creates a 'src' dir to place python files in and sets PYTHONPATH to point to this.

DEFAULT_PYTHON_VERSION="3.9"


# Display usage info
usage() {
    echo "Usage: $0 <target_name> [-n <env_name>] [-v <version>]"
    echo "  <target_name>  (mandatory) Name of repo in which to create the Python env."
    echo "  -n <env_name>  (optional)  Name for the Python Env (if different than repo name)."
	echo "  -v <version>   (optional)  Python version to use for the environment (default: $DEFAULT_PYTHON_VERSION)"
    exit 1
}

# Parse input
if [ -z "$1" ]; then
	usage
fi
TARGET_NAME="$1"
TARGET_DIR="./$TARGET_NAME"
ENV_NAME="$TARGET_NAME"
PYTHON_VERSION=$DEFAULT_PYTHON_VERSION

# Parse optional flags
shift  # Shift positional argument off so getopts processes only flags
while getopts "n:v:" opt; do
    case "$opt" in
	    n) ENV_NAME="$OPTARG" ;;
        v) PYTHON_VERSION="$OPTARG" ;;
        \?) usage ;;
    esac
done


# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Cannot create Python environment."
    echo "'$TARGET_DIR' does not exist."
    exit 1
fi
# Check if the target directory is a git repo
if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "Cannot create Python environment."
    echo "'$TARGET_DIR' is not a git repository."
    exit 1
fi


# Create and configure the conda environment
cd "$TARGET_DIR"
mkdir src
conda create -y --name "$ENV_NAME" python=$PYTHON_VERSION
conda run -n "$ENV_NAME" --live-stream conda env config vars set PYTHONPATH="$(pwd)"/src
conda run -n "$ENV_NAME" --live-stream conda env export --from-history > environment.yml

# Commit the environment specification to git
git add environment.yml
git commit -m "created conda environment and specified installed dependencies in environment.yml"
git push

echo "Python environment '$ENV_NAME' created successfully."
echo "Type <conda activate $ENV_NAME> to use it now."