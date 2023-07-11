# Torch GPU Container Initialization

## Updates

Jul 11: 
* Fixed a bug that will make python38 environment miss some packages

## Introduction

This repo is used to build up a Docker Deep Learning environment from scratch.

The container environment includes:

* NVIDIA drive including CUDA:12.0
* NVIDIA NVCC:11.7
* MiniConda environment
    * "base" environment:
        * Python 3.10
        * with torch (gpu)
    * "python38" environment (only available in conda-heavy):
        * Python 3.8
        * with torch (gpu)
        * requirement packages
    * "python39" environment (only available in conda-heavy):
        * Python 3.9
        * with torch (gpu)
        * requirement packages
* frpc that can be used to connect outside the LAN.

<!-- The python38 and python39 environment includes:
* eventlet
* matplotlib
* tensorboardx
* opencv-python
* pandas
* Pillow
* scikit-image
* scikit-learn
* scipy
* seaborn
* sentry-sdk
* urllib3
* tensorboard
* timm
* tqdm -->

## Prerequisites

A host machine with:
* NVIDIA drive, CUDA version >=12.0
* Docker
* NVIDIA Docker environment (refer to [NVIDIA official site](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#installation-guide))


There are several folders under `templates/basic`, each folder is a workspace that containes the environment to build up a docker image. The structure of a single workspace is shown below:

```bash
└── parent_folder
    ├── Dockerfile	        # dockerfile with the instructions to build the container
    ├── container_init.sh   # script to build image & start container
    └── scripts		        # a folder contains all the scripts and packages that will be copied into the container
        ├── conda-torch-gpu-setup-python38.sh   # python38 installation script
        ├── conda-torch-gpu-setup-python39.sh   # python39 installation script
        ├── frp_0.47.0_linux_amd64.tar.gz       # frp installation script
        ├── frpc.ini                            # frp client config
        ├── miniconda-install.sh                # miniconda installation script
        ├── miniconda.sh            # miniconda official install script & binary files
        ├── requirements.txt        # python packages to be installed in python38 and python39
        ├── startup.sh              # script to run on the container startup
        └── welcome-message         # text to show when logged into the container

```

By running `container_init.sh`, you can build up the docker image. Also, by altering the attributes in `container_init.sh` you may specify the detail of the container image. By setting `CONTAINER_CREATE=True`, you may create a container after the image is generated.

Also, by default there are two mounted directories shown below, and you may specify the directories in `container_init.sh`:
* Host machine's `/home/docker-private-dir/$CONTAINER_NAME/` will be mounted on container's `/home/workenv/`.
* Host machine's `/data/` will be mounted on container's `/data/`.

## How to start

First, Build basic container image with nvidia drive & nvcc & miniconda.

The image will be stored as `dl-basic:1.0-nvcc-conda`.

```bash
cd templates/basic/conda-basic/
bash container_init.sh
```

Second, Build heavy containerimage  with nvidia drive & nvcc & miniconda & python38 and python39 conda environments.  

The image will be stored as `dl-heavy:1.0-nvcc-conda`.

```bash
cd ../conda-heavy/
bash container_init.sh
```

If success, run `docker images`, you may find your docker image.
```bash
docker images
# REPOSITORY        TAG                           IMAGE ID       CREATED          SIZE
# dl-heavy          1.0-nvcc-conda                612b1ed0938b   11 minutes ago   32.7GB
# dl-basic          1.0-nvcc-conda                50f26497ede3   21 minutes ago   14GB
```

Now you have the images. Next, you may copy and alter `container_init.sh` to build your self specified container.

## Some issues & solutions

* [Cannot find environments such as nvcc or python when logged in using ssh](https://stackoverflow.com/questions/69788652/why-does-path-differ-when-i-connect-to-my-docker-container-with-ssh-or-with-exec)




