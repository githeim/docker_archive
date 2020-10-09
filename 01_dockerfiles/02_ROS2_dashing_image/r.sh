#!/bin/bash
source ./common.sh
CONTAINER_NAME=ros2_dashing_test
if [ $# -gt 0 ]
then
  CONTAINER_NAME=$1
fi
echo container name - $CONTAINER_NAME
echo now, start

sudo docker run -it --name $CONTAINER_NAME  \
  --privileged --env="DISPLAY=:1"\
  --net=host \
  -v$DOCKER_SHARED_DIR:/home/ubuntu/share \
  $ROS2_IMAGE_NAME /bin/bash
