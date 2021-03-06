#!/bin/bash

# :x: include common env variables
source ./common.sh
CONTAINER_NAME=ubuntu18_base_test
if [ $# -gt 0 ]
then
  CONTAINER_NAME=$1
fi
echo image name - $DOCKER_IMG_NAME
echo container name - $CONTAINER_NAME
echo now, start


sudo docker run -it --name $CONTAINER_NAME  \
  --privileged --env="DISPLAY=$DISPLAY"\
  --net=host \
  -v$DOCKER_SHARED_DIR:/home/ubuntu/share \
  $DOCKER_IMG_NAME /bin/bash
