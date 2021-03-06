#!/bin/bash
trap error_callback ERR

error_callback() {
  echo 'Error Occurs'
  exit 1
}
export DOCKER_SHARED_DIR=$HOME/docker_share
export DOCKER_IMG_NAME="ubuntu18_base:0.1"
export DOCKER_BASE_IMG=ubuntu:18.04 
export COMMON_DIR_PATH=../../02_commons
export COMMON_DOCKERFILE_PATH=$COMMON_DIR_PATH/00_dockerfile
export TARGET_DOCKERFILE=ubuntu18_base_Dockerfile 

