#!/bin/bash

# Copyright (C) 2018 The University of Leeds
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author: Rafael Papallas (rpapallas.com), Wissam Bejjani (https://github.com/WissBe)

export DEBIAN_FRONTEND=noninteractive
echo 'export LANG=C.UTF-8' >> $SINGULARITY_ENVIRONMENT
echo 'export LC_ALL=C.UTF-8' >> $SINGULARITY_ENVIRONMENT
source $SINGULARITY_ENVIRONMENT

apt-get -y update

apt-get install -y vim

apt-get install -y \
    cmake \
    g++ \
    git \
    ipython \
    octave \
    python-dev \
    python-h5py \
    python-numpy \
    python-pip \
    python-scipy \
    python-sympy \
    qt4-dev-tools \
    zlib-bin

apt-get install -y \
    libassimp-dev \
    libavcodec-dev \
    libavformat-dev \
    libavformat-dev \
    libboost-all-dev \
    libboost-date-time-dev \
    libbullet-dev \
    libfaac-dev \
    libfreetype6-dev \
    libglew-dev \
    libgsm1-dev \
    liblapack-dev \
    libmpfi-dev \
    libmpfr-dev \
    libode-dev \
    libogg-dev \
    libpcre3-dev \
    libpcrecpp0 \
    libqhull-dev \
    libqt4-dev \
    libsoqt-dev-common \
    libsoqt4-dev \
    libswscale-dev \
    libswscale-dev \
    libvorbis-dev \
    libx264-dev \
    libxml2-dev \
    libxvidcore-dev

apt-get install -y \
    software-properties-common

apt-get -y update

# ROS Stuff
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
apt-get update
apt-get install -y ros-indigo-desktop-full

rosdep init

apt-get -y install python-rosinstall

apt-get -y update
apt-get -y install wget

# OpenRAVE
apt-get -y install collada-dom-dev

## OpenSceneGraph
mkdir -p /build/
cd /build
git clone https://github.com/openscenegraph/OpenSceneGraph.git --branch OpenSceneGraph-3.4
cd OpenSceneGraph
mkdir build; cd build
cmake .. -DDESIRED_QT_VERSION=4
make -j `nproc`
make install

## FCL
apt-add-repository ppa:imnmfotmal/libccd
apt-get update
apt-get install -y libccd
cd /build
git clone https://github.com/flexible-collision-library/fcl
cd fcl; git reset --hard 0.5.0
mkdir build; cd build
cmake ..
make -j `nproc`
make install

## Downgrade sympy to work with OpenRAVE
pip install --upgrade --user sympy==0.7.1

## Build OpenRAVE from source
cd /build
git clone https://github.com/rdiankov/openrave.git
cd openrave
mkdir build; cd build
cmake -DODE_USE_MULTITHREAD=ON -DOSG_DIR=/usr/local/lib64/ ..
make -j `nproc`
make install

# OpenRAVE UR5 Controller
apt-get install -y libtinyxml2-dev
apt-get install -y ros-indigo-srdfdom
apt-get install -y ros-indigo-soem
