# Torch GPU Container Configuration

This repo is used to build up a Docker Deep Learning environment from scratch.

The container environment includes:

* NVIDIA drive including CUDA:12.0
* NVIDIA NVCC:11.7
* MiniConda environment
    * "base" environment (conda-basic):
        * Python 3.10
        * with torch (gpu)
    * "python38" environment (conda-heavy):
        * Python 3.8
        * with torch (gpu)
    * "python39" environment (conda-heavy):
        * Python 3.9
        * with torch (gpu)
* frpc that can be used to connect outside the LAN.

## Prerequisites

A host machine with:
* NVIDIA drive, CUDA version >=12.0
* Docker
* Environmental settings (refer to [NVIDIA official site](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#installation-guide))

A dockerfile workspace with the structure shown below:
```bash
└── parent_folder
    ├── Dockerfile	        # Dockerfile mentioned above
    ├── container_init.sh   # Script to build image & start container
    └── scripts		        # A folder contains all the scripts and packages that will be copied into the container
        ├── conda-torch-gpu-setup-python38.sh
        ├── conda-torch-gpu-setup-python39.sh
        ├── frp_0.47.0_linux_amd64.tar.gz
        ├── frpc.ini
        ├── miniconda-install.sh
        ├── miniconda.sh
        ├── requirements.txt
        ├── startup.sh
        └── welcome-message

```

Also, you need to prepare the directories on the host that will be mounted on the container. The following are default settings and can be specified in `container_init.sh`:
* `/home/docker-private-dir/$CONTAINER_NAME/` will be mounted on `/home/workenv/`.
* `/data/` will be mounted on `/data/`.

## How to start

```bash
# 1. Build basic container with nvidia drive & nvcc & miniconda & required python packages. 
# The image will be stored as dl-basic:1.0-nvcc-conda.
cd templates/basic/conda-basic/
bash container_init.sh

# If success, run `docker ps`, you may find your container.
docker ps

# 2. Build heavy container with nvidia drive & nvcc & miniconda & python38 and python39 conda environments.
# The image will be stored as dl-heavy:1.0-nvcc-conda.
cd ../conda-heavy/
bash container_init.sh

# 3. Build your self specified container by altering container_init.sh
```

## Some issues & solutions

* [Cannot find environments such as nvcc or python](https://stackoverflow.com/questions/69788652/why-does-path-differ-when-i-connect-to-my-docker-container-with-ssh-or-with-exec)




