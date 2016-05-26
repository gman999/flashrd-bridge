#!/bin/sh -x
# take new flashrd image, extract 3 files and upload to remote host(s)

img="${img:-flashimg.`uname -m`-date}"	# {date} will depend on image
img_path="${img_path:-$HOME/flashrd}"
user="${user:-upgrader}"		# the remote scp'er
files="${files:-{bsd,openbsd.vnd,var.tar}}"
remote="${remote:-xxx.xxx.xxx.xxx}"	# or use a list

# if it's not working out, let's just end it
yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }

vnconfig vnd0 $img;

mount /dev/vnd0a /mnt;

cd /mnt;

scp $files $user@$remote:/flash/new;

umount /mnt;

vnconfig -u vnd0;
