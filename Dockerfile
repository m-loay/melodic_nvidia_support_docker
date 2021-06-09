# This Dockerfile is used to build an ROS + OpenGL + Gazebo + Tensorflow image based on Ubuntu 18.04
FROM nvidia/cudagl:10.0-devel-ubuntu18.04

LABEL maintainer "Mohamed Loay"
MAINTAINER Mohamed Loay "https://github.com/m-loay"
ENV REFRESHED_AT 2019-02-12

# Install sudo
RUN apt-get update && \
    apt-get install -y sudo apt-utils curl

RUN sudo apt-get update && sudo apt-get -y upgrade

# Environment config
ENV DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_FRONTEND=noninteractive
ENV CATKIN_WS /root/ros_ws

# Add new sudo user
ARG user=ros
ARG passwd=ros
ARG uid=1000
ARG gid=1000
ENV USER=$user
ENV PASSWD=$passwd
ENV UID=$uid
ENV GID=$gid
RUN useradd --create-home -m $USER && \
        echo "$USER:$PASSWD" | chpasswd && \
        usermod --shell /bin/bash $USER && \
        usermod -aG sudo $USER && \
        echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USER && \
        chmod 0440 /etc/sudoers.d/$USER && \
        # Replace 1000 with your user/group id
        usermod  --uid $UID $USER && \
        groupmod --gid $GID $USER

### ROS and Gazebo Installation
# Install other utilities
RUN apt-get update && \
    apt-get install -y vim \
    tmux \
    git \
    wget \
    lsb-release \
    lsb-core

# Install ROS
ENV DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_FRONTEND=noninteractive
RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN sudo apt update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN sudo apt-get install -y ros-melodic-desktop-full
RUN /bin/bash -c "echo 'source /opt/ros/melodic/setup.bash' >> /root/.bashrc"
RUN sudo apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
RUN sudo apt install -y python-rosdep
RUN sudo rosdep init
RUN rosdep update


### finning ROS setup
RUN sudo apt-get update && sudo apt-get -y upgrade


# Expose Jupyter 
EXPOSE 8888

# Expose Tensorboard
EXPOSE 6006

### Switch to root user to install additional software
USER $USER
