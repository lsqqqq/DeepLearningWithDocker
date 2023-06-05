#!/bin/bash

# This script is used to create a single container
# If you failed to create or start the container, you may
# run the following commands to remove the things created in
# the middle:

# docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
# docker rmi $IMAGE:$IMG_VERSION

### Settings ###

## Container settings
# Container name
CONTAINER_NAME='gpuclient1'

## Image settings
# Container image name (without version)
IMAGE="dl-basic"
# Container image version
IMG_VERSION="1.0"

## Host settings
# Root password in container
ROOT_PASSWD="ROOT_PASSWD"
# Host port. You can visit the container via host_ip:HOST_PORT.
HOST_PORT=6001
# Server port

## FRP settings
# Whether to start frp service. Set ENABLE_FRP=True to enable frp.
ENABLE_FRP=False
# FRP server ip
SERVER_IP="SERVER_IP"
# FRP server port. 
# You can visit the container via frp_server_ip:SERVER_PORT if frp is enabled.
SERVER_PORT="SERVER_PORT"

### Container Initialization ###
# Create image
image_exists=`docker images | grep $IMAGE` | grep $IMG_VERSION
if [ $image_exists ]
then
    echo "Image exist, skipped..."
else
    echo "Image does not exist, will start to create the image in 10 seconds..."
	sleep 10
	echo "Start building container from scratch..."
    docker build -t $IMAGE:$IMG_VERSION .
fi

# Create the container
docker run -dit \
	-e ROOT_PASSWD=$ROOT_PASSWD \
	-e SERVER_IP=$SERVER_IP \
	-e SERVER_PORT=$SERVER_PORT \
	-e ENABLE_FRP=$ENABLE_FRP \
	-p $HOST_PORT:22 \
	-v /data:/data \
	-v /home/docker-private-dir/$CONTAINER_NAME:/home/workenv \
	-h=$CONTAINER_NAME \
	--name=$CONTAINER_NAME \
	--restart=always \
	$IMAGE:$IMG_VERSION \
	/root/scripts/startup.sh