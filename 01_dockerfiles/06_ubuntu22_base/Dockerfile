FROM ubuntu:22.04

ARG user=ubuntu
ARG user_passwd=4321
ARG host_account
ARG docker_shared_dir

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Update and install all packages in a single RUN to minimize layers
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
    lsb-core \
    language-pack-ko \
    openssh-server \
    build-essential \
    cmake \
    python3 python3-dev python3-pip \
    libncurses5-dev \
    unzip git zip \
    make \
    wget exuberant-ctags vim tmux curl libzmq3-dev \
    g++ lcov doxygen graphviz rpcbind \
    gcc-arm-linux-gnueabi g++-arm-linux-gnueabi \
    default-jre \
    sudo \
    net-tools \
    libgtest-dev \
    libsdl2-dev \
    mc htop tig \
    mesa-utils \
    alsa-utils alsa-oss libasound2-dev libasound2-plugins \
    pulseaudio-utils pulseaudio libpulse0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8

# Install repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo && \
    chmod a+x /usr/bin/repo && \
    ln -s /usr/bin/python3 /usr/bin/python


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

# Configure bash prompt with bright yellow [CONTAINER] label
RUN echo "" >> /home/$user/.bashrc && \
    echo "# Custom container prompt" >> /home/$user/.bashrc && \
    echo "PS1=\"\\[\\033[1;33m\\][CONTAINER]\\[\\033[0m\\] \\u@\\h:\\w$ \"" >> /home/$user/.bashrc

# # :x: install wh_dev
# RUN mkdir -p /home/$user/00_work/00_wh_dev
# WORKDIR /home/$user/00_work/00_wh_dev
# RUN git clone https://github.com/githeim/wh_dev.git -b ubuntu_22_04
# WORKDIR /home/$user/00_work/00_wh_dev/wh_dev
# USER root
# RUN ./prerequisite_des.sh
# USER $user
# RUN ./des.py
WORKDIR /home/$user

CMD /bin/bash	
