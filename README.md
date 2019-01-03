# UR5 Controller Singularity

<p align="center">
    <img src="images/ur5_openrave.png" alt="UR5 with OpenRAVE within a singularity container"> <br/>
    Figure 1: UR5 Robot with Ridgeback and RobotiQ end-effettor in OpenRAVE within a Singularity container with Ubuntu 14.04 and ROS Indigo.
</p>

## Developers and Contributors
UR5Controller Singulairyt was developed by the Robotics Lab in the School of Computing at the University of Leeds. 
- Author: [Rafael Papallas](http://rpapallas.com), [Wissam Bejjani](https://github.com/WissBe).
- Current maintainor: [Rafael Papallas](http://rpapallas.com), [Wissam Bejjani](https://github.com/WissBe).

## License
UR5Controller Singularity is licensed under GNU General Public License v3.0. 
The full license is available [here](https://github.com/roboticsleeds/ur5controller_singularity/blob/master/LICENSE). 

## Instructions

This is a Singularity container for [`ur5controller`](https://github.com/roboticsleeds/ur5controller)
package.

Clone and build the singularity:

```
git clone https://github.com/roboticsleeds/ur5controller_singularity
cd ur5controller_singularity
./build.sh
```

This should create a local Ubuntu 14.04 file system with ROS Indigo, `or\_urdf`,
and `ur5controller` in it. 

It will take a while to build (approximately 40 minutes). Once built, you will
automatically enter into the singualrity environment (which will build your catkin
workspace).

When you need to enter your singularity environment, simply run `./run.sh`.

This should put you into a singularity environment. To test if everything was
succesful you can run:
```
cd ~/ur5_demo
python ur5_demo.py
```

And you should see an OpenRAVE window with UR5 being loaded.

## Binding directories
As you can see from the above configuration you can have a `home` directory living
on your host machine and then bind that directory as the home directory of the
container. As a result you can now put files under that `home` dir and both the
host and the container can read and write in it.

Another way to do this is to bind the directory using `--bind` (`--bind=absolute_path_of_source_dir:absolute_path_of_target_dir`) flag:
```
singularity run --contain --home=home:$HOME --bind=/home/rafael/Documents/my_project:/home/my_project ur5controller
```

This will bind `/home/rafael/Documents/my_project` to container's `/home` directory.

Unfortunetly, you can't bind the target directory to container's user home (e.g `/home/rafael`) directory. 
We found a workaround to this. Under `home/.bashrc` of this repository we have placed
the following code:

```
# Delete all links that are broken
find ./ -maxdepth 1 -follow  -type l -delete

# This code is to create a symbolic link of any directory located under /home/.
# When you use --bind in singularity to bind a directory from host to the container
# you can't bind that directory under $HOME but only under /home/, therefore a
# workaround to this was to create a symbolic link to all fo the directories under
# /home/ to $HOME.
for dir in ../*/
do
    if [ "$dir" != "../$USER/" ]; then
        ln -sf $dir .
    fi;
done
```

This code will create symbolic links for every directory located under container's
`/home/` directory to `$HOME` (i.e., `/home/user_name`).

So with the above `.bashrc` code whenever you start a singularity container like this:
```
singularity run --contain --home=home:$HOME --bind=/home/rafael/Documents/my_project:/home/my_project ur5controller
```

Will bind `/home/rafael/Documents/my_project` to `/home/my_project/` and will create
a symbolic link of `/home/my_project/` to `/home/rafael/my_project`. As a result
we are "binding" a directory from the host file system to the container under
container's user home directory.

**With all that said, if you want to bind a directory to the container you just
need to edit the `run.sh` file and add `--bind=source:target` as you wish.**

For example:

```
singularity run --contain --home=home:$HOME --bind=/home/rafael/Documents/my_project_1:/home/my_project_1 --bind=/home/rafael/Documents/my_project_2:/home/my_project_2 ur5controller
```

Here we are binding two directories: `my_project_1` and `my_project_2`.


## Notes
- Note that we have pre-generated the robot inverse kinematics for OpenRAVE and
placed them under your singularity home directory just to save time as this 
takes a while. This is just the kinematics for our specific configuration, if you
change the model then OpenRAVE will generate new IK solutions for your new model.
- During build time we create some temporary files (`scripts` and `build`) that we
are using to build everything. Once finished we erase those files.
- The `home` directory located under this repository contains the following important
data: `.openrave` with the prepoulated IK solutions to UR5 robot, `.bashrc` containing
important commands to successfully run ROS and the UR5Controller.
- Anything you create in the container under `home` will be persistent but if you
write anything outside `home` this will not be writable. If you need to make changes
to the singularity container, then run `write.sh` to enter into a root session within
your singularity container.
- You can work in `home` directory outside singularity (say if you are using an 
IDE software) and the changes should be immediately available within the 
singularity environment. So you can edit your source code outside the container
using your host machine and then execute the code within the container.
