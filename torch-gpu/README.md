# Torch GPU Container Configuration

This repo is used to build up a Docker Deep Learning environment from scratch.

The container environment includes:

* NVIDIA drive including CUDA:12.0
* MiniConda with "base" and "python39" environment
    * "base" environment:
        * Python 3.10.10
    * "python39" environment:
        * Python 3.9.16
        * pytorch==2.0.0
        * torchvision==0.15.0
        * torchaudio==2.0.0
        * pytorch-cuda=11.7
* frpc that can be used to connect outside the LAN.

## Prerequisites
A host machine with:
* NVIDIA drive, CUDA version >=12.0
* Docker includes nvidia-docker2

A dockerfile workspace with the structure shown below:
```bash
└── torch-gpu
    ├── Dockerfile	# Dockerfile mentioned above
    ├── README.md	# Instructions
    ├── scripts		# A folder contains all the scripts and packages that will be copied into the container
    │   ├── conda-torch-gpu-setup.sh
    │   ├── frp_0.47.0_linux_amd64.tar.gz
    │   ├── frpc.ini
    │   ├── miniconda-install.sh
    │   ├── miniconda.sh
    │   ├── startup.sh
    │   └── welcome-message
    └── docker_build.sh		# Script to build the container
    └── container_init.sh
```

Also, you need to prepare the directories on the host that will be mounted on the container:
* `/home/docker-private-dir/$CONTAINER_NAME` will mounted on `/home/workenv`.
* `/data` will be mounted on `/data/`.

## How to start

1. Alter `container_init.sh` to meet your demand. You may also change the versions of packages or something else by altering the files under `./scripts/` and the `Dockerfile`.
2. Run `chmod +x container_init.sh && bash container_init.sh` to start the process.
3. If success, run `docker ps`, you may find your container.


## Some issues & solutions

* [Cannot find environments such as nvcc or python](https://stackoverflow.com/questions/69788652/why-does-path-differ-when-i-connect-to-my-docker-container-with-ssh-or-with-exec)




