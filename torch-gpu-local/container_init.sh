#!/bin/bash

# This script is used to create a single container.

# Usage:
# 	

# If you failed to create or start the container, you may
# run the following commands to remove the things created in
# the middle:

# docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
# docker rmi $SAVE_IMAGE

### Settings ###

## Container settings
CONTAINER_CREATE=True
CONTAINER_NAME='gpuclient1'
DOCKERFILE="Dockerfile_python39_openslide"

## Image settings
# Be careful, you may only choose images with cuda:11.7 drive, otherwise you cannot install pytorch successfully.
BASE_IMAGE="nvidia/cuda:11.7.1-devel-ubuntu22.04"
SAVE_IMAGE="dl/conda:1.0"
EXPORT_IMAGE=False
EXPORT_IMAGE_NAME='dl-conda.tar'

## Mount settings
MOUNT_WORKSPACE_SRC="`pwd`/workspace"
MOUNT_WORKSPACE_DEST="/home"
MOUNT_DATA_SRC="`pwd`/data"
MOUNT_DATA_DEST="/data"

## Remote settings
SSH_ENABLE=False
HOST_PORT=3826
ROOT_PASSWD="InitPass123"

# Function to display help information
display_help() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --base_image <docker image name>     	Set the base Docker image name. By default, $BASE_IMAGE."
  echo "  --save_image <docker image name>      Set the saved Docker image name. By default, $SAVE_IMAGE."
  echo "  --dockerfile <filename>    			Dockerfile. You may choose different dockerfile under ./container/dockerfiles for different environment. By default, $DOCKERFILE."
  echo "  --export_img <bool>      				Whether to export your image into file. By default, $EXPORT_IMAGE."
  echo "  --export_img_name <filename>      	Compressed Docker image name (a tar file). By default, $EXPORT_IMAGE_NAME."
  echo "  --container_create <bool>      		Whether to create container. By default, $CONTAINER_CREATE."
  echo "  --container_name <container name>    	Container name. By default, $CONTAINER_NAME."
  echo "  --mount_workspace <src>:<dest>		Mounted workspace directory. By default, $MOUNT_WORKSPACE_SRC:$MOUNT_WORKSPACE_DEST."
  echo "  --mount_data <src>:<dest>				Mounted dataset directory. By default, $MOUNT_DATA_SRC:$MOUNT_DATA_DEST."
  echo "  --ssh_enable <bool>      				Whether to enable remote ssh. By default, $SSH_ENABLE."
  echo "  --host_port <bool>      				Your host port. If ssh is enabled, you may visit your container at <host_ip>:<host_port>. By default, $HOST_PORT."
  echo "  --root_passwd <bool>      			Root password. If ssh is enabled, you may use this password to access your container. By default, $ROOT_PASSWD."
  echo "  -h, --help             Display this help message"
}

# Loop through command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --base_image)  # If argument is "--container_name"
            BASE_IMAGE="$2"  # Set the value of the path variable to the next argument
            shift  # Shift the arguments to the left
            shift  # (Note: This discards the current argument and moves to the next one)
            ;;
        --save_image)
            SAVE_IMAGE="$2"
            shift
            shift
            ;;
		--export_img)
            EXPORT_IMAGE="$2"
            shift
            shift
            ;;
        --export_img_name)
            EXPORT_IMAGE_NAME="$2"
            shift
            shift
            ;;
		--container_create)
            CONTAINER_CREATE="$2"
            shift
            shift
            ;;
		--container_name)
            CONTAINER_NAME="$2"
            shift
            shift
            ;;
		--mount_workspace)
            MOUNT_WORKSPACE="$2"
			IFS=':' read -r MOUNT_WORKSPACE_SRC MOUNT_WORKSPACE_DEST <<< "$MOUNT_WORKSPACE"
			if [[ -z "$MOUNT_WORKSPACE_SRC" || -z "$MOUNT_WORKSPACE_DEST" ]]; then
				echo "Error: Please provide both source and destination directories using --mount_workspace /src:/dest"
				exit 1
			fi
            shift
            shift
			;;
		--mount_data)
            MOUNT_DATA="$2"
			IFS=':' read -r MOUNT_DATA_SRC MOUNT_DATA_DEST <<< "$MOUNT_DATA"
			if [[ -z "$MOUNT_DATA_SRC" || -z "$MOUNT_DATA_DEST" ]]; then
				echo "Error: Please provide both source and destination directories using --mount_data /src:/dest"
				exit 1
			fi
            shift
            shift
			;;
		--ssh_enable)
            SSH_ENABLE="$2"
            shift
            shift
            ;;
		--host_port)
            HOST_PORT="$2"
            shift
            shift
            ;;
		--root_passwd)
            ROOT_PASSWD="$2"
            shift
            shift
            ;;
		--dockerfile)
            DOCKERFILE="$2"
            shift
            shift
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

div_line=$(printf "%$(tput cols)s" | tr ' ' '#')

echo ""
echo "### Settings ###"
echo $div_line

echo "## Container settings"
echo "CONTAINER_CREATE=$CONTAINER_CREATE"
echo "CONTAINER_NAME='$CONTAINER_NAME'"
echo "DOCKERFILE=\"$DOCKERFILE\""

echo -e "\n## Image settings"
echo "BASE_IMAGE=\"$BASE_IMAGE\""
echo "SAVE_IMAGE=\"$SAVE_IMAGE\""
echo "EXPORT_IMAGE=$EXPORT_IMAGE"
echo "EXPORT_IMAGE_NAME='$EXPORT_IMAGE_NAME'"

echo -e "\n## Mount settings"
echo "MOUNT_WORKSPACE_SRC=\"$MOUNT_WORKSPACE_SRC\""
echo "MOUNT_WORKSPACE_DEST=\"$MOUNT_WORKSPACE_DEST\""
echo "MOUNT_DATA_SRC=\"$MOUNT_DATA_SRC\""
echo "MOUNT_DATA_DEST=\"$MOUNT_DATA_DEST\""

echo -e "\n## Remote settings"
echo "SSH_ENABLE=$SSH_ENABLE"
echo "HOST_PORT=$HOST_PORT"
echo "ROOT_PASSWD=\"$ROOT_PASSWD\""

### Container Initialization ###

echo ""
echo "### Container Initialization ###"
echo $div_line

# Check if image already exists
image_exists=$(docker images -q $SAVE_IMAGE 2> /dev/null)

# Stop running if any error occured
set -e

if [[ $image_exists ]]
then
    echo "Image exist, no need to build again..."
else
    echo "Image does not exist, will start to create the image in 10 seconds..."
	sleep 10
	echo "Start building container from scratch..."
	cp ./container/dockerfiles/$DOCKERFILE Dockerfile
	docker build \
		-t $SAVE_IMAGE \
		--build-arg BASE_IMG=$BASE_IMAGE \
		.
	rm Dockerfile
fi

echo "Creating temporary container for test..."
docker run -dit \
	-h=temp_container \
	--gpus all \
	--name=temp_container \
	--restart=always \
	$SAVE_IMAGE \
	/root/scripts/startup.sh

set +e

echo "Checking container gpu capability..."
nvidia_capable=$(docker exec --tty temp_container nvidia-smi)
if [[ $nvidia_capable ]]; then
	echo -e "\033[32m[OK]\033[0m Docker gpu environment exist. Container checked successful"
	docker stop temp_container && docker rm temp_container
else
	echo -e "\033[31m[Failed]\033[0m Docker gpu environment test failed, aborted."
	docker stop temp_container && docker rm temp_container
	exit 1
fi

set -e

# Export image to the file
if [[ $EXPORT_IMAGE == True ]]; then
	echo "Exporting the Docker image to: $EXPORT_IMAGE_NAME..."
	docker save -o $EXPORT_IMAGE_NAME $SAVE_IMAGE
fi

# Create the container
if [[ $CONTAINER_CREATE == True ]]
then
	echo "Creating container $CONTAINER_NAME..."
	if [[ $SSH_ENABLE == True ]]
	then
		docker run -dit \
			-e ROOT_PASSWD=$ROOT_PASSWD \
			-v $MOUNT_DATA_SRC:$MOUNT_DATA_DEST \
			-v $MOUNT_WORKSPACE_SRC:$MOUNT_WORKSPACE_DEST \
			-h=$CONTAINER_NAME \
			-p $HOST_PORT:22 \
			--name=$CONTAINER_NAME \
			--restart=always \
			--gpus all \
			--shm-size=16g \
			$SAVE_IMAGE \
			/root/scripts/startup.sh

		# Init ssh key
		docker exec --tty $CONTAINER_NAME ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa

	else
		docker run -dit \
			-e ROOT_PASSWD=$ROOT_PASSWD \
			-v $MOUNT_DATA_SRC:$MOUNT_DATA_DEST \
			-v $MOUNT_WORKSPACE_SRC:$MOUNT_WORKSPACE_DEST \
			-h=$CONTAINER_NAME \
			--name=$CONTAINER_NAME \
			--restart=always \
			--gpus all \
			--shm-size=16g \
			$SAVE_IMAGE \
			/root/scripts/startup.sh
	fi

	echo ""
	echo "Docker container generated successful."
	echo "The mount status:"
	echo ""
	echo "	workspace: $MOUNT_WORKSPACE_SRC (host) -> $MOUNT_WORKSPACE_DEST (container)"
	echo "	data: $MOUNT_DATA_SRC (host) -> $MOUNT_DATA_DEST (container)"
	echo ""
	echo "You may get inside the Docker container using the following command:"
	echo ""
	echo "  docker exec -it $CONTAINER_NAME bash"
	echo ""
	echo "To remove the container and the Docker image:"
	echo ""
	echo "  docker stop $CONTAINER_NAME"
	echo "  docker rm $CONTAINER_NAME"
	echo "  docker rmi $SAVE_IMAGE"
	echo ""

	if [[ $SSH_ENABLE == True ]]
	then
		echo "You have enabled remote ssh for your container. "
		echo "To access your container remotely, use the following command:"
		echo ""
		echo "	ssh -p $HOST_PORT root@<host_ip>"
		echo ""

		if [[ $ROOT_PASSWD == "InitPass123" ]]
		then
			echo "Your default password is $ROOT_PASSWD. Please change after logged in."
			echo "To change the root password, using the following command:"
			echo ""
			echo '	echo "root:<your_password>" | chpasswd'
			echo ""
		fi
	fi
fi

echo -e "\033[32mAll finished, exit.\033[0m"

set +e
