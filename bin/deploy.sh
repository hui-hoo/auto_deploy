#!/usr/bin/env bash

source ../lib/bash/libscripts.bash

# add new user wsapce
wspace_shell=$(which bash)
if [ -z "$wspace_shell" ];then
    error_log "Can't find bash in PATH"
fi

password=$(openssl passwd -1 "hhm123456")
username="wspace"
actual_home="/usr/local/$username"
home="/home/$username"
info="standard user to run business processes"
basic_group="$username"
max_disk="/data"


if grep -qw $username /etc/passwd;then
    userdel  $username 
fi

# clean up some old data or process owned by user
remove_dirs $home $actual_home
pkill -u  $username 1>/dev/null 2>&1

useradd -r -U -m -d $home -s $wspace_shell -p $password $username -k ../etc/skel

# make home a soft link to actual_home
remove_dirs $home $actual_home
mkdir -p  $actual_home
ln -s $actual_home $home

# create wspace layout
# every module lib should put library in $home/lib
# log and tmp should be in the biggest partition
mkdir -p $home/{sbin,bin,etc,lib,data,var/{run,lock}}
mkdir -p  $max_disk/{src,log,tmp,include,doc,man}  # the biggest partition
for dir in src log tmp doc man
do
    ln -s $max_disk/$dir $home/data/$dir
done


# some useful tools configuration
cp -f ../etc/vim/.vimrc $home/
cp -f ../etc/skel/.[^.]* $home/

# change owner
chown -R $username:$basic_group $actual_home
