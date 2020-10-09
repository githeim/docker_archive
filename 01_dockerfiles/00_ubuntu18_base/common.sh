#!/bin/bash
trap error_callback ERR

error_callback() {
  echo 'Error Occurs'
  exit 1
}
export DOCKER_SHARED_DIR=$HOME/docker_share
export DOCKER_IMG_NAME="ubuntu18_base:0.1"

