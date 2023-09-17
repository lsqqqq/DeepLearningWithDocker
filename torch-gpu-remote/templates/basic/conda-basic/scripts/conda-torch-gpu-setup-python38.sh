#!/bin/bash
source /root/miniconda3/bin/activate
conda activate base

# Install conda
conda info -e
conda create -n python38 python=3.8 -y
conda activate python38

# Install pytorch-gpu
conda install -y pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia

# Install required packages
pip install -r /root/scripts/requirements.txt
pip install --no-index --find-links=/root/scripts//package  -r /root/scripts/requirements.txt

# Install ipkernels to enable jupyter notebook
conda install -n python38 ipykernel --update-deps --force-reinstall

# Test installation result
cuda_enable=`python -c "import torch;print(torch.cuda.is_available())"`
echo "CUDA available: $cuda_enable"
if [ $cuda_enable == True ]
then
    echo "CUDA enabled"
else
    echo "Failed to enable CUDA, aborted"
    exit 1
fi

