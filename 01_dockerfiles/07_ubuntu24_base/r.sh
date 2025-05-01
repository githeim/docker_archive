#!/bin/bash

# :x: include common env variables
source ./common.sh

CONTAINER_NAME=ubuntu24_base_instance
if [ $# -gt 0 ]
then
  CONTAINER_NAME=$1
fi
echo container name - [$CONTAINER_NAME]
echo now, start


sudo docker run -it --name $CONTAINER_NAME  \
  --privileged \
  --env="DISPLAY=${DISPLAY}" \
  --cap-add=SYS_PTRACE \
  --security-opt=seccomp:unconfined \
  --security-opt=apparmor:unconfined \
  --ipc=host \
  --net=host \
  --device="/dev/dri" \
  --device /dev \
  --device /dev/snd \
  --group-add="dialout" \
  --group-add="plugdev" \
  -v /tmp/.Xauthority:/tmp/.Xauthority \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /run/user/$(id -u):/run/user/$(id -u) \
  --volume="/dev:/dev" \
  -v$DOCKER_SHARED_DIR:/home/ubuntu/share \
  $DOCKER_IMG_NAME /bin/bash
