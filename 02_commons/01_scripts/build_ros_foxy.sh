#!/bin/bash
set -x
trap 'catch' ERR
catch() {
	echo "An error has occured, now exit 1"
	exit 1
}
source ./common_ros2_foxy_build.sh
export ROS2_PKGS=ros_base \
          launch_xml \
          launch_yaml \
          cv_bridge \
          image_transport \
          navigation2
export ROS2_PKGS='ros_base launch_xml launch_yaml cv_bridge image_transport navigation2'
export ARCH=$(uname -m)
sudo mkdir -p /opt/ros/${ROS2_DISTRO} 
sudo chmod 777 -R /opt/ros/

sudo apt update && sudo apt install locales -y
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

sudo apt update && sudo apt -y install curl gnupg2 lsb-release
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

# Install dependencies:
sudo apt update
sudo apt-get install -y \
  build-essential \
  git \
  cmake \
  libbullet-dev \
  libpython3-dev \
  python3-colcon-common-extensions \
  python3-flake8 \
  python3-pip \
  python3-pytest-cov \
  python3-rosdep \
  python3-setuptools \
  python3-vcstool \
  python3-rosinstall-generator \
  libasio-dev \
  libtinyxml2-dev \
  libcunit1-dev

python3 -m pip install -U \
  argcomplete \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  pytest-repeat \
  pytest-rerunfailures \
  pytest

sudo apt-get install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev

sudo apt-get install --no-install-recommends -y \
  libcunit1-dev

sudo apt-get -y install build-essential libboost-system-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev  libboost-all-dev \
  freeglut3-dev mesa-common-dev libgl1-mesa-dev libglu1-mesa-dev mesa-utils
sudo apt-get -y install libopenal-dev libvorbis-dev libfreetype6-dev libx11-dev libirrlicht-dev libjpeg-dev libbz2-dev

sudo apt update && sudo apt upgrade -y

# Build and install yaml-cpp 0.6 which is not included in Ubuntu 18.04
echo "Building space for YAML: $(pwd)"
git clone --branch yaml-cpp-0.6.0 https://github.com/jbeder/yaml-cpp yaml-cpp-0.6
mkdir -p yaml-cpp-0.6/build \
  && cd yaml-cpp-0.6/build \
  && cmake -DBUILD_SHARED_LIBS=ON .. \
  && make -j$(nproc) \
  && sudo make install
sudo cp libyaml-cpp.so.0.6.0 /usr/lib/${ARCH}-linux-gnu
sudo ln -s /usr/lib/${ARCH}-linux-gnu/libyaml-cpp.so.0.6.0 /usr/lib/${ARCH}-linux-gnu/libyaml-cpp.so.0.6
cd ../.. && rm -rf yaml-cpp-0.6

# Build and install behaviortree
#echo "Building space for behaviortree: $(pwd)"
#git clone https://github.com/BehaviorTree/BehaviorTree.CPP.git BehaviorTree.CPP
#mkdir -p BehaviorTree.CPP/build \
#  && cd BehaviorTree.CPP/build \
#  && cmake .. \
#  && make -j$(nproc) \
#  && sudo make install
#cd ../.. && rm -rf BehaviorTree.CPP

# Update CMake by building from source:
if [[ ${ARCH} == "aarch64" ]]; then
  sudo apt purge cmake -y
  wget https://github.com/Kitware/CMake/releases/download/v3.19.3/cmake-3.19.3.tar.gz
  tar xvf cmake-3.19.3.tar.gz
  cd cmake-3.19.3
  ./bootstrap && make -j$(nproc --all) && sudo make install
  cd ..
  rm -rf cmake*
elif [[ ${ARCH} == "x86_64" ]]; then
  wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
  sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
  sudo apt-get update && sudo apt-get upgrade -y
else
  echo "System architecture other than aarch64 and x86_64 cannot be recognized."
  exit 1
fi

# sync out ros2 sources:
cd ${ROS2_PATH}
sudo chmod 777 -R ${ROS2_PATH}
mkdir -p ${ROS2_PATH}/src
echo $ROS2_PKGS
rosinstall_generator --deps --rosdistro foxy $ROS2_PKGS > ros2.${ROS2_DISTRO}.rosinstall
vcs import src < ros2.${ROS2_DISTRO}.rosinstall

# Run rosdep:
sudo apt-get update && sudo apt-get install -y python3-colcon-common-extensions
# sudo rm -rf /etc/ros/rosdep/sources.list.d/20-default.list
sudo rosdep init
rosdep update
rosdep install -y -r --from-paths src --ignore-src --rosdistro ${ROS2_DISTRO} --skip-keys "rti-connext-dds-5.3.1"

# Build ros2 pkgs
touch src/navigation2/COLCON_IGNORE
touch src/behaviortree_cpp_v3/COLCON_IGNORE
colcon build
