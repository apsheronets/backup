#!/bin/bash

source config

backup_name=$1

sshfs_mountpoint=$working_dir/${backup_name}.sshfs.restore
squashfs_mountpoint=$working_dir/${backup_name}.squashfs.restore

# unmounting everything
sudo umount $squashfs_mountpoint
rm -rf $squashfs_mountpoint
sudo cryptsetup luksClose $backup_name
sudo umount $sshfs_mountpoint
rm -rf $sshfs_mountpoint
