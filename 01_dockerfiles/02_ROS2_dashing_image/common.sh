#!/bin/bash
trap error_callback ERR

PRC_STEP=0
error_callback() {
  echo 'Error Occurs'
  echo 'in Step '$PRC_STEP
  exit 1
}
step_call() {      
  PRC_STEP=$((PRC_STEP+1)) 
  echo 'STEP='$PRC_STEP
}                  

export DOCKER_SHARED_DIR=$HOME/docker_share
export ROS2_IMAGE_NAME="ros2_img:dashing"

