#!/bin/bash
trap error_callback ERR

error_callback() {
  echo 'Error Occurs'
  exit 1
}

sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# To install ros2 pkgs
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc > OpenRobotics.key
sudo apt-key add OpenRobotics.key
sudo apt-get update -y
sudo apt-get install -y apt-utils
# time zone install
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
# cross build toolchain
sudo apt install g++-aarch64-linux-gnu gcc-aarch64-linux-gnu -y

# vcstool
sudo apt-get install -y python3-pip
sudo apt-get install -y python-pip
sudo apt-get update -y
sudo apt-get install -y python3-vcstool

sudo sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'

export CHOOSE_ROS_DISTRO=dashing

sudo apt update -y
sudo apt install -y curl gnupg2 lsb-release
sudo apt install -y ros-$CHOOSE_ROS_DISTRO-desktop
sudo apt install -y python3-argcomplete python3-colcon-common-extensions

## rqt
sudo apt-get install -y ros-$CHOOSE_ROS_DISTRO-rqt*

## cartographer_ros_docs
sudo apt-get install -y python-sphinx libdw-dev

## nav2_util
sudo apt-get install -y libsdl-dev libsdl1.2-dev libsdl-image1.2-dev
sudo apt-get install -y ros-$CHOOSE_ROS_DISTRO-test-msgs
## nav2_map_server
sudo apt-get install -y libbullet-dev
sudo apt-get install -y graphicsmagick-libmagick-dev-compat # from 0.2.4
sudo apt-get install -y ros-$CHOOSE_ROS_DISTRO-gazebo-ros-pkgs

## nav2_tasks
sudo apt-get install -y ros-$CHOOSE_ROS_DISTRO-behaviortree-cpp
## nav2_costmap_2d
sudo apt-get install -y ros-$CHOOSE_ROS_DISTRO-tf2-sensor-msgs

## ros2bag
sudo apt-get install -y ros-$CHOOSE_ROS_DISTRO-ros2bag ros-$CHOOSE_ROS_DISTRO-rosbag2-storage*
sudo apt-get install -y libceres-dev
sudo apt-get install -y liblua5.2-dev
sudo apt-get install -y libcairo2-dev

## for gazebo
sudo apt-get install -y ros-$CHOOSE_ROS_DISTRO-gazebo-ros

## for usb interfaces
sudo apt-get install -y libusb-1.0.0-dev

## for realsense2
sudo apt install -y ros-$CHOOSE_ROS_DISTRO-librealsense2/bionic
## for Vision support
sudo apt install -y ros-$CHOOSE_ROS_DISTRO-cv-bridge/bionic
sudo apt install -y ros-$CHOOSE_ROS_DISTRO-image-transport
sudo apt install -y ros-$CHOOSE_ROS_DISTRO-image-transport-plugins

## for protobuf
sudo apt install -y libprotobuf-dev protobuf-compiler

## for pyyaml
sudo apt-get install python3-pip
pip3 install pyyaml

## for gtk2 support 
sudo apt-get install -y libgtk2.0-dev

