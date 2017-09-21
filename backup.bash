#!/bin/bash

source config

postfix=f
backup_name=$(date +"%Y%m%d%H%M%S")$postfix
sshfs_mountpoint=$working_dir/${backup_name}.sshfs

# mounting the remote directory through ssh
mkdir -p $sshfs_mountpoint
sshfs $remote_user@$remote_host:$remote_path $sshfs_mountpoint -o $ssh_opts,reconnect,allow_root || exit 1

# creating an empty LUKS container
dd of=$sshfs_mountpoint/${backup_name}.in_progress bs=1 count=0 seek=$sparse_file_size
cryptsetup luksFormat --batch-mode --key-file $key_file $sshfs_mountpoint/${backup_name}.in_progress

# mountint the LUKS container as a block device
sudo cryptsetup luksOpen --key-file $key_file $sshfs_mountpoint/${backup_name}.in_progress $backup_name

# making a full backup and writing it directly to the LUKS device
sudo mksquashfs $root_to_backup /dev/disk/by-id/dm-name-$backup_name -noappend

# unmounting everything
sudo cryptsetup luksClose $backup_name
mv $sshfs_mountpoint/${backup_name}.in_progress $sshfs_mountpoint/${backup_name}
sudo umount $sshfs_mountpoint
rm -rf $sshfs_mountpoint


#luks_mountpoint=/home/komar/luks
#free_lo=$(losetup -f)
#sudo mount /dev/disk/by-id/dm-name-$backup_name $luks_mountpoint
#sudo umount $luks_mountpoint
#losetup -d $free_lo
