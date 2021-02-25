#!/bin/bash
# :x: include common env variables
source ./common.sh
cp $COMMON_DOCKERFILE_PATH/$TARGET_DOCKERFILE ./Dockerfile

sudo docker build --rm=true --force-rm=true --no-cache \
  --tag $DOCKER_IMG_NAME \
  --build-arg BASE_IMG=${DOCKER_BASE_IMG} \
  --build-arg docker_shared_dir=${DOCKER_SHARED_DIR} \
  .
