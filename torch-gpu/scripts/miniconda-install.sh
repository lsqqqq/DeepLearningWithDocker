#!/bin/bash
# Define the Miniconda version and target installation directory
MINICONDA_VERSION="latest"
INSTALL_DIR="$HOME/miniconda3"

# Download the Miniconda installer
wget "https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" -O miniconda.sh


# Run the installer in silent mode
bash miniconda.sh -b -p "$INSTALL_DIR"

# Add Miniconda to the system PATH
echo "export PATH=$PATH:/usr/local/cuda/bin" >> "$HOME/.bashrc"
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64" >> "$HOME/.bashrc"
# source $HOME/.bashrc
source $INSTALL_DIR/bin/activate

# Verify the installation
conda --version

echo "Miniconda installation completed!"