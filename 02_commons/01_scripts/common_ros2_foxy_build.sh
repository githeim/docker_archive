#!/bin/bash
trap 'catch' ERR
catch() {
	echo "An error has occured, now exit 1"
	exit 1
}

export DOCKER_SHARED_DIR=$HOME/docker_share                 
export DOCKER_IMG_NAME="ros2_foxy_ubuntu_1804:0.1"          
export DOCKER_BASE_IMG=ubuntu18_base 
export COMMON_DIR_PATH=../../02_commons
export COMMON_DOCKERFILE_PATH=$COMMON_DIR_PATH/00_dockerfile
export TARGET_DOCKERFILE=ubuntu18_base_Dockerfile 


export ROS2_DISTRO=foxy
export ROS2_PATH=/opt/ros/$ROS2_DISTRO
