FROM ubuntu:22.04

ARG user=ubuntu
ARG user_passwd=ubuntu4321
ARG host_account
ARG docker_shared_dir 

RUN echo [$host_account]
RUN echo [$docker_shared_dir]

# to solve tzdata problem
RUN apt-get update  -y 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata

RUN apt-get update && apt-get install -q -y \
        lsb-core
RUN apt-get update
RUN apt-get install -y language-pack-ko
 
# set locale ko_KR
RUN locale-gen ko_KR.UTF-8

ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

# update aptget
RUN  apt-get -y update 
RUN  apt-get -y upgrade

# ssh server
RUN  apt-get install -y openssh-server 

# basic options
RUN  apt-get install -y build-essential 
RUN  apt-get install -y cmake 
RUN  apt-get install -y python3 python3-dev 
RUN  apt-get install -y libncurses5-dev 
RUN  apt-get install -y unzip git zip
RUN  apt-get install -y make
RUN  apt-get install -y wget exuberant-ctags vim tmux curl
RUN  apt-get install -y g++ scons lcov doxygen graphviz rpcbind gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
RUN  apt-get install -y build-essential
RUN  apt-get install -y default-jre 
RUN  apt-get install -y sudo
RUN  apt-get install -y net-tools
RUN  apt-get install -y libgtest-dev
RUN  apt-get install -y libsdl2-dev 
# install repo
RUN  curl https://storage.googleapis.com/git-repo-downloads/repo >  /usr/bin/repo
RUN  chmod a+x /usr/bin/repo
RUN  ln -s /usr/bin/python3 /usr/bin/python

# basic utils
RUN  apt-get install -y mc htop 
RUN apt-get install -y mesa-utils

# user add
RUN useradd -ms /bin/bash $user -G sudo
# setting default passwd
RUN echo root:$user_passwd | chpasswd
RUN echo $user:$user_passwd | chpasswd

# :x: share point
VOLUME [$docker_shared_dir]

# :x: add git encryption algorithm to suppress error
RUN sh -c "echo 'KexAlgorithms +diffie-hellman-group1-sha1' >> /etc/ssh/ssh_config"
RUN sh -c "echo 'PubkeyAcceptedAlgorithms +ssh-rsa' >> /etc/ssh/ssh_config"
RUN sh -c "echo 'HostkeyAlgorithms +ssh-rsa' >> /etc/ssh/ssh_config"

USER $user
WORKDIR /home/$user
RUN mkdir /home/$user/share

# :x: install wh_dev
RUN mkdir -p /home/$user/00_work/00_wh_dev
WORKDIR /home/$user/00_work/00_wh_dev
RUN git clone https://github.com/githeim/wh_dev.git -b ubuntu_22_04
WORKDIR /home/$user/00_work/00_wh_dev/wh_dev
USER root
RUN ./prerequisite_des.sh
USER $user
RUN ./des.py
WORKDIR /home/$user

CMD /bin/bash	
