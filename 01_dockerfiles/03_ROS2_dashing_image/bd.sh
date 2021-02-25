#!/bin/bash
# :x: include common env variables
source ./common.sh
#cp ~/.ssh/id_rsa     ./ssh_files && cp ~/.ssh/id_rsa.pub ./ssh_files
#if [ "$?" = "0" ] ; then
#  echo Copy ssh files done
#else
#  echo Can not copy the ssh files
#  exit 1
#fi

sudo docker build --rm=true --force-rm=true --no-cache --tag $ROS2_IMAGE_NAME .
