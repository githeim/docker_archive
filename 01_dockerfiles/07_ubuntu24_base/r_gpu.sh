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
  --gpus='all,"capabilities=compute,utility,graphics,display"' \
  --runtime nvidia \
  --device="/dev/dri" \
  --device /dev \
  -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
  -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
  -v ~/.config/pulse/cookie:/home/ubuntu/.config/pulse/cookie:ro \
  -e PULSE_COOKIE=/home/ubuntu/.config/pulse/cookie \
  --device /dev/snd \
  --group-add $(getent group audio | cut -d: -f3) \
  --group-add="dialout" \
  --group-add="plugdev" \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -v $DOCKER_SHARED_DIR:/home/ubuntu/share \
  -v /tmp/.Xauthority:/tmp/.Xauthority \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /run/user/$(id -u):/run/user/$(id -u) \
  --volume="/dev:/dev" \
  $DOCKER_IMG_NAME /bin/bash
