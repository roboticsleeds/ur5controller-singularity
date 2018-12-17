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

# If catkin_ws does not exist on user's home folder, then we create a catkin 
# workspace, and clone all the packages needed including the ur5controller.
if [ ! -d "$HOME/catkin_ws" ]; then
    touch $HOME/.bashrc
    echo "source /opt/ros/indigo/setup.bash" >> $HOME/.bashrc
    source $HOME/.bashrc

    mkdir -p $HOME/catkin_ws/src
    cd $HOME/catkin_ws/
    catkin_make
    echo "source $HOME/catkin_ws/devel/setup.bash" >> $HOME/.bashrc
    source $HOME/.bashrc

    echo "export ROS_MASTER_URI=http://localhost:11311" >> $HOME/.bashrc
    echo "export ROS_HOSTNAME=localhost" >> $HOME/.bashrc
    source $HOME/.bashrc

    # OpenRAVE UR5 Controller
    cd $HOME/catkin_ws/src
    git clone https://github.com/personalrobotics/openrave_catkin.git
    git clone https://github.com/rpapallas/or_urdf.git
    source $HOME/.bashrc
    cd $HOME/catkin_ws
    catkin_make

    echo "export OPENRAVE_PLUGINS=$OPENRAVE_PLUGINS:$HOME/catkin_ws/devel/share/openrave-0.9/plugins" >> $HOME/.bashrc

    cd $HOME/catkin_ws/src
    git clone https://github.com/ros-industrial/robotiq.git
    cd robotiq
    git checkout indigo-devel
    rosdep update
    rosdep install robotiq_modbus_tcp

    cd $HOME/catkin_ws
    catkin_make

    cd $HOME/catkin_ws/src
    git clone https://github.com/roboticsleeds/ur5controller.git
    echo "export PYTHONPATH=$PYTHONPATH:$HOME/catkin_ws/src/ur5controller/pythonsrc/ur5_robot" >> $HOME/.bashrc
    cd $HOME/catkin_ws
    catkin_make

    echo ""
    echo ""
    echo "Your catkin_ws is now ready. You are now in a singularity environment."
    cd ~
fi

# Throw user into a bash
/bin/bash
