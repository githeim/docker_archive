#!/bin/sh
trap error_callback ERR
                       
error_callback() {     
  echo 'Error Occurs'  
  exit 1
}                      

sudo apt-get remove docker docker-engine -y
sudo apt-get update -y

sudo apt-get install \
  linux-image-extra-$(uname -r) \
      linux-image-extra-virtual -y

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
         stable"
sudo apt-get update -y
sudo apt-get install docker-ce -y

# docker machine 설치
curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
# docker registry image를 받는다
sudo docker pull registry:2.6.1

