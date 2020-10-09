FROM ubuntu18_base:0.1

RUN echo ros2 base image
ARG USER=ubuntu
USER ${USER}
WORKDIR /home/$user

USER ${USER}

# ROS2 installer 복사
COPY ros2_installer.sh        /home/ubuntu
USER root
RUN sudo chown ubuntu:ubuntu /home/ubuntu/ros2_installer.sh        
USER ${USER}

# git 관련 설정
RUN git config --global user.email "johndoe@nowhere.com"
RUN git config --global user.name  "johndoe"
RUN git config --global push.default matching
RUN git config --global diff.tool vimdiff
RUN git config --global merge.tool vimdiff
RUN git config --global merge.conflictstyle diff3
ENV GIT_EDITOR=vim
ENV EDITOR=vim

WORKDIR /home/${USER}
# ros2 installation
USER root
RUN ./ros2_installer.sh 

USER ${USER}
