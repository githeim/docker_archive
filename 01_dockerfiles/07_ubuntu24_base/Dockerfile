FROM ubuntu:24.04

ARG user=ubuntu
ARG user_passwd=4321
ARG host_account
ARG docker_shared_dir

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Update and install all packages in a single RUN to minimize layers
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
    tzdata \
    lsb-release \
    language-pack-ko \
    openssh-server \
    build-essential \
    cmake \
    python3 python3-dev python3-pip \
    sshpass \
    ptpd \
    libncurses5-dev \
    unzip git zip git-lfs \
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
    ibus ibus-hangul \
    fonts-noto-cjk \
    dbus \
    libxkbfile-dev \
    libsecret-1-dev \
    x11-apps \
    x11-utils \
    dbus-x11 dbus \
    gedit \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Microsoft repository for VS Code
RUN apt-get update && \
    apt-get install -y --no-install-recommends gpg && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null && \
    apt-get update && \
    apt-get install -y --no-install-recommends code && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locale for Korean support
RUN locale-gen en_US.UTF-8 && \
    locale-gen ko_KR.UTF-8

# Install repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo && \
    chmod a+x /usr/bin/repo && \
    ln -s /usr/bin/python3 /usr/bin/python


# User add with sudo privileges
RUN useradd -ms /bin/bash $user 2>/dev/null || true && \
    echo "$user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo root:$user_passwd | chpasswd && \
    echo $user:$user_passwd | chpasswd

# :x: share point
VOLUME [$docker_shared_dir]

# :x: add git encryption algorithm to suppress error
RUN sh -c "echo 'KexAlgorithms +diffie-hellman-group1-sha1' >> /etc/ssh/ssh_config"
RUN sh -c "echo 'PubkeyAcceptedAlgorithms +ssh-rsa' >> /etc/ssh/ssh_config"
RUN sh -c "echo 'HostkeyAlgorithms +ssh-rsa' >> /etc/ssh/ssh_config"

RUN mkdir -p /home/ubuntu/.config /home/ubuntu/.code && \
    chown -R $user:$user /home/ubuntu/.config /home/ubuntu/.code

# Initialize ibus registry (run as root)
RUN mkdir -p /var/cache/ibus && \
    chmod 755 /var/cache/ibus

# Copy entrypoint script and set permissions while root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chown $user:$user /usr/local/bin/entrypoint.sh

USER $user
WORKDIR /home/$user
RUN mkdir -p /home/$user/share

# Configure bash prompt with bright yellow [CONTAINER] label
RUN echo "" >> /home/$user/.bashrc && \
    echo "# Custom container prompt" >> /home/$user/.bashrc && \
    echo "PS1=\"\\[\\033[1;33m\\][CONTAINER]\\[\\033[0m\\] \\u@\\h:\\w$ \"" >> /home/$user/.bashrc

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]	
