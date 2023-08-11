#!/bin/bash

# :x: include common env variables
source ./common.sh
export DOCKER_IMG_NAME="ubuntu22_base:0.1"

CONTAINER_NAME=ubuntu22_base_instance
if [ $# -gt 0 ]
then
  CONTAINER_NAME=$1
fi
echo container name - [$CONTAINER_NAME]
echo now, start


sudo docker run -it --name $CONTAINER_NAME  \
  --privileged --env="DISPLAY=:1"\
  --net=host \
  --gpus all \
  --runtime nvidia \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -v$DOCKER_SHARED_DIR:/home/ubuntu/share \
  $DOCKER_IMG_NAME /bin/bash
