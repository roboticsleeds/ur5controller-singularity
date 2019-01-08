# Delete all links that are broken
find ./ -maxdepth 1 -follow -type l -delete

# This code is to create a symbolic link of any directory located under /home/.
# When you use --bind in singularity to bind a directory from host to the container
# you can't bind that directory under $HOME but only under /home/, therefore a
# workaround to this was to create a symbolic link to all fo the directories under
# /home/ to $HOME.
for filename in $(find /home -maxdepth 1 ! -path "/home/$USER" ! -path '*/\.*' ! -path '/home'); do
    ln -sf $filename $HOME
done

