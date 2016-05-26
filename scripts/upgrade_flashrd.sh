#!/bin/sh -x
# to reside on flashrd host and run after new files in $new

# not really necessary since standard
flash="${flash:-/flash}"
old="${old:-$flash/old}"
new="${new:-$flash/new}"

# if it's not working out, let's just end it
yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }

try cp $flash/{bsd,openbsd.vnd,var.tar} $old;

try mv $new/{bsd,openbsd.vnd,var.tar} $flash;

echo "Rebooting with new contents of /flash, but we'll regress to /flash/old if it won't boot";

try reboot;
