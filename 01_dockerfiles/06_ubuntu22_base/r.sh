#!/bin/bash

# :x: include common env variables
source ./common.sh

CONTAINER_NAME=ubuntu20_base_instance
if [ $# -gt 0 ]
then
  CONTAINER_NAME=$1
fi
echo container name - [$CONTAINER_NAME]
echo now, start


sudo docker run -it --name $CONTAINER_NAME  \
  --privileged --env="DISPLAY=:0"\
  --net=host \
  -v$DOCKER_SHARED_DIR:/home/ubuntu/share \
  $DOCKER_IMG_NAME /bin/bash
