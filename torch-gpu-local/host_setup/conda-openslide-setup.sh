#!/bin/bash

# Default conda environment
CONDA_ENV="python39"

# Function to display help information
display_help() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --conda_env <conda environment>     	Set the conda environment to install openslide. By default, $CONDA_ENV."
  echo "  -h, --help             Display this help message"
}

# Loop through command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --conda_env)  # If argument is "--container_name"
            CONDA_ENV="$2"  # Set the value of the path variable to the next argument
            shift  # Shift the arguments to the left
            shift  # (Note: This discards the current argument and moves to the next one)
            ;;
        -h|--help)
            display_help
            exit 0
            ;;
        *)  # If argument is not recognized
            echo "Unknown option: $key"
            exit 1
            ;;
    esac
done

set -e

# Activate conda environment
source $HOME/miniconda3/bin/activate
conda activate ${CONDA_ENV}

# # Install dependencies
# export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libffi.so.7
# apt-get install -y libopenslide0
# apt-get install -y openslide-tools
conda install -c conda-forge openslide -y

# Install openslide
pip install openslide-python

# Test installation result
openslide_enable=`python -c "import openslide"`
if [[ $openslide_enable ]]
then
    echo "Failed to enable Openslide, aborted."
    exit 1
else
    echo "Openslide installed successfully."
fi

set +e
