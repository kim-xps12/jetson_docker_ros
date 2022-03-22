FROM nvcr.io/nvidia/l4t-base:r32.5.0
MAINTAINER B-SKY Lab 


# Set values 
ENV USER docker 
ENV PASSWORD docker 
ENV HOME /home/${USER} 
ENV SHELL /bin/bash 
ENV DEBIAN_FRONTEND=noninteractive


# nvidia-container-runtime 
ENV NVIDIA_VISIBLE_DEVICES=all 
ENV NVIDIA_DRIVER_CAPABILITIES=all


# Install basic tools 
RUN apt update && apt upgrade -y 
RUN apt install -y tzdata 
ENV TZ=Asia/Tokyo 
RUN apt install -y sudo \  
                   vim-gtk \
                   git \
                   tmux \
                   gnupg2 \
                   glmark2 \
                   libgl1-mesa-glx \
                   libgl1-mesa-dri \
                   libglu1-mesa-dev \
                   libgles2-mesa-dev \
                   freeglut3-dev \            
                   build-essential \
                   bash-completion \
                   command-not-found \
                   software-properties-common \
                   xdg-user-dirs \
                   xsel \
                   dirmngr \
                   gpg-agent \
                   mesa-utils \
                   curl


# ROS settings
ARG ROS_PKG=ros-base
ENV ROS_DISTRO=melodic

RUN curl -Ls https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'


# install ROS packages
RUN apt update && \
    apt install -y --no-install-recommends \
    ros-melodic-${ROS_PKG} \
    ros-melodic-image-transport \
    ros-melodic-vision-msgs \
    ros-melodic-rviz \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    python-catkin-tools \
    python-vcstool


# init/update rosdep
RUN rosdep init


# Create user and add to video group and sudo group 
RUN useradd --user-group --create-home --shell /bin/false ${USER} 
RUN gpasswd -a ${USER} video 
RUN gpasswd -a ${USER} sudo 
RUN echo "${USER}:${PASSWORD}" | chpasswd 
RUN sed -i.bak "s#${HOME}:#${HOME}:${SHELL}#" /etc/passwd


# Set defalut user 
USER ${USER} 
WORKDIR ${HOME} 
SHELL ["/bin/bash", "-c"] 
RUN echo "export PATH=/usr/local/cuda/bin:$PATH" >> ~/.bashrc
RUN echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH" >> ~/.bashrc
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc


# update and load ROS settings
RUN rosdep update
RUN source ~/.bashrc


# Change name color at terminal 
# Green (default) --> Light Cyan 
RUN cd ~ 
RUN sed s/32/36/ .bashrc > .bashrc_tmp 
RUN mv .bashrc_tmp .bashrc

