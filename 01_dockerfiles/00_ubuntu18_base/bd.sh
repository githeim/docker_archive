#!/bin/bash

# :x: include common env variables
source ./common.sh

mkdir -p $DOCKER_SHARED_DIR
sudo docker build --no-cache \
  --build-arg host_account=$USER \
  --build-arg docker_shared_dir=$DOCKER_SHARED_DIR \
  --tag $DOCKER_IMG_NAME .

