FROM isaac-sim:2023.1.0-ubuntu22.04
#ubuntu 22.04 jammy amd64
#docker build -f ubuntu22.04_isaacsim_ros2humble_pkgdep.Dockerfile --build-arg NUM_THREADS=8 --tag=isaac-sim_test:v0.6 .
MAINTAINER Chen Yang <yangchen.98@bytedance.com>

ENV DEBIAN_FRONTEND noninteractive

RUN set -x && \
  apt-get update -y -qq && \
  apt-get upgrade -y -qq --no-install-recommends && \
  apt-get install -y -qq \
    libyaml-cpp-dev curl software-properties-common \
    vim v4l-utils exfat-* \
    openssh-server \
    terminator dbus-x11 \
    python3-pip && \
  : "remove cache" && \
  apt-get autoremove -y -qq && \
  rm -rf /var/lib/apt/lists/*

# cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" && \
    apt update && \
    apt install -y -qq cmake

# ros2
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt update && \
    apt-get upgrade -y -qq --no-install-recommends && \
    apt install -q -y \
    libfmt-dev librange-v3-dev pkg-config doxygen
RUN pip install -U pip \
    pip install -U jinja2 typeguard

RUN apt update && \
    apt-get upgrade -y -qq --no-install-recommends && \
    apt install -q -y \
    ros-dev-tools ros-humble-desktop-full ros-humble-vision-msgs ros-humble-ur-description \
    ros-humble-test-msgs  ros-humble-controller-interface ros-humble-backward-ros ros-humble-ackermann-msgs ros-humble-control-toolbox \
    ros-humble-generate-parameter-library ros-humble-controller-manager \
    ros-humble-ros2-control ros-humble-ros2-controllers ros-humble-kinematics-interface-kdl \
    ros-humble-ur-msgs ros-humble-ur-client-library \
    ros-humble-backward-ros ros-humble-ackermann-msgs ros-humble-control-toolbox ros-humble-generate-parameter-library ros-humble-gazebo-dev \
    ros-humble-gazebo-ros ros-humble-kinematics-interface ros-humble-kinematics-interface-kdl

RUN echo 'export ROS_PACKAGE_PATH=/opt/ros/humble/share' >> ~/.bashrc
RUN echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc
#RUN echo 'source /isaac-sim/setup_python_env.sh' >> ~/.bashrc

ENTRYPOINT ["/bin/bash"]