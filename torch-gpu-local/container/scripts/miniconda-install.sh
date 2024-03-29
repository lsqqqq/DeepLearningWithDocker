#!/bin/bash
# Define the Miniconda version and target installation directory
MINICONDA_VERSION="latest"
INSTALL_DIR="$HOME/miniconda3"
SCRIPT_DIR="/root/scripts"

# Download the Miniconda installer
miniconda_exists=`find $SCRIPT_DIR -name miniconda.sh`
if [ $miniconda_exists ]
then
    echo "Found existing miniconda installer!"
else
    wget "https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" -O $SCRIPT_DIR/miniconda.sh
fi

# Run the installer in silent mode
bash $SCRIPT_DIR/miniconda.sh -b -p "$INSTALL_DIR"

# Add Miniconda to the system PATH
echo "export PATH=$PATH:/usr/local/cuda/bin" >> "$HOME/.bashrc"
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64" >> "$HOME/.bashrc"
# source $HOME/.bashrc
source $INSTALL_DIR/bin/activate

# Initialize conda
conda init

echo "Miniconda installation completed!"