#!/bin/bash

# :x: include common env variables
source ./common.sh
CONTAINER_NAME=ubuntu18_GPU_nvidia_test
if [ $# -gt 0 ]
then
  CONTAINER_NAME=$1
fi
echo image name - $DOCKER_IMG_NAME
echo container name - $CONTAINER_NAME
echo now, start

sudo docker run -it --name $CONTAINER_NAME  \
  --privileged --env="DISPLAY=$DISPLAY"\
  --gpus all \
  --runtime nvidia \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=display,compute,utility \
  --net=host \
  -v$DOCKER_SHARED_DIR:/home/ubuntu/share \
  $DOCKER_IMG_NAME /bin/bash
