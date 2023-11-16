FROM osrf/ros:melodic-desktop-full

# Set environment 
ARG ROS_DISTRO=melodic 

ENV ROS_DISTRO=$ROS_DISTRO 

ENV ROS_VERSION=2 \ 
    ROS_PYTHON_VERSION=2

# Install Dependencies 
RUN apt update

RUN apt install -y \
    python-rosdep \ 
    python-pip \
    wget

RUN apt-get install -y \ 
    libcanberra-gtk-module dbus \
    dbus-x11 \
    xterm
# removed gnome-terminal
RUN pip install pyserial \
    pip install setuptools==2.0 \ 
    pip install vcstool \
    pip install pyserial

# Make directories 
RUN mkdir -p -- ~/ros_ws/src   

# Update rosdeps 
RUN cd ~/ros_ws/src \ 
    rosdep install -y \ 
    --from-paths src \  
    --ignore-src \  
    --skip-keys " \ 
    fastcdr \  
    rti-connext-dds-6.0.1 \ 
    urdfdom_headers"
 
WORKDIR /root/ros_ws 
RUN  /bin/bash -c 'git clone https://github.com/dufrenekm/rob537_cable_follow.git src \
    && source /opt/ros/melodic/setup.bash \
    && chmod -R 755 src \
    && catkin_make'
RUN apt install ros-melodic-ur-robot-driver -y
RUN apt upgrade -y 

RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc 
RUN echo "source ~/ros_ws/devel/setup.bash" >> ~/.bashrc
RUN echo "cd ~/ros_ws" >> ~/.bashrc
RUN export ROS_PACKAGE_PATH=/ros_ws/:$ROS_PACKAGE_PATH

RUN echo "echo 'Terminal sourced using /opt/ros/melodic/setup.bash'" >> ~/.bashrc 
