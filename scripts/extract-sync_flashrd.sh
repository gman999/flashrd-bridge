#!/bin/sh -x
# take new flashrd image, extract 3 files and upload to remote host

img="${img:-flashimg.i386-date}"
img_path="${img_path:-$HOME/flashrd}"
remote="${remote:-xxx.xxx.xxx.xxx}"

vnconfig vnd0 $img;

mount /dev/vnd0a /mnt;

cd /mnt;

scp bsd openbsd.vnd var.tar root@$remote:/flash/new;

umount /mnt;

vnconfig -u vnd0;
