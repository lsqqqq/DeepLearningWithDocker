#!/bin/bash

# Install conda
conda create -n -y python39 python=3.9
conda activate python39

# Install pytorch-gpu
conda install -y pytorch==2.0.0 torchvision==0.15.0 torchaudio==2.0.0 pytorch-cuda=11.7 -c pytorch -c nvidia

# Test installation result
cuda_enable=`python -c "import torch;print(torch.cuda.is_available())"`
echo "Cuda available: $cuda_enable"
if [ $cuda_enable == True ]
then
    echo "CUDA enabled"
else
    echo "Failed to enable CUDA, aborted"
    exit 1
fi