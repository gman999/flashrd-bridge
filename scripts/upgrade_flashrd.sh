#!/bin/sh -x
# to run on flashrd host

flash="${flash:-/flash}"
old="${old:-$flash/old}"
new="${new:-$flash/new}"

cp $flash/{bsd,openbsd.vnd,var.tar} $old;

mv $new/{bsd,openbsd.vnd,var.tar} $flash;

reboot;

echo "Rebooting with new contents of /flash, but we'll regress to /flash/old if it won't boot";
