#!/bin/bash

source config

backup_name=$1

sshfs_mountpoint=$working_dir/${backup_name}.sshfs.restore
squashfs_mountpoint=$working_dir/${backup_name}.squashfs.restore

# mounting the remote directory through ssh
mkdir -p $sshfs_mountpoint
sshfs $remote_user@$remote_host:$remote_path $sshfs_mountpoint -o $ssh_opts,reconnect,allow_root,ro || exit 1

# mounting the LUKS container as a block device
sudo cryptsetup luksOpen --key-file $key_file $sshfs_mountpoint/$backup_name $backup_name

mkdir -p $squashfs_mountpoint
sudo mount /dev/disk/by-id/dm-name-$backup_name $squashfs_mountpoint -o ro

echo mounted to:
echo $squashfs_mountpoint
echo please check out this directory, then run ./unmount.bash
