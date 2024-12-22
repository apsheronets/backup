A backup utility written in bash
================================

This is a proof-of-concept piece of code, use at your own risk.

Setup
-----

    sudo apt-get install squashfs-tools cryptsetup-bin ncdu

Configuration
-------------

This tool allows you to achieve relatively small size of backup file. You could see what is getting to be archived by running `ncdu`:

    ncdu -X exclude -x /

You can edit `exclude` file and run `ncdu` again until all of your gargabe will be out of scope.

They you can host your file whenever you want, because it is encrypted by LUKS. To set the keyfile, edit `config`:

    key_file=/root/mykeyfile

You can use anything as a key. Plain text, random bytes, whatever.

Usage
-----

"Backup" — make a file:

    sudo ./backup /root/backups/$(hostname)_$(date +"%Y%m%d%H%M%S")

"Restore" — mount a file:

    sudo ./mount /root/backups/pc_20241223020347 /mnt/temp

Umount a file:

    sudo ./umount /mnt/temp


issues
------

 * `ncdu -X` and `mksquashfs -wildcards -ef` have different understanding of wildcards.
 * * `/one/*/three` rule means whatever levels of directories for `ncdu`, but `mksquashfs` would only match one level.
