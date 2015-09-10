#!/bin/sh -x
# tor for _tor group and torsocks for git
# NEEDS = torsocks git

#set -e

now="${now:-`date "+%Y%m%d"`}"
ver="${ver:-`uname -r`}"
sysver="${sysver:-`uname -r | tr -d "."`}"
# i386 supports both Soekris and Alix boards
arch="${arch:-`uname -m`}"
#mach="${mach:-ALIX}"
flashrdpath="${flashrdpath:-$HOME/flashrd$sysver}"
buildpath="${buildpath:-$flashrdpath/openbsd}"
mirror="${mirror:-ftp://mirrors.nycbug.org/pub/OpenBSD/snapshots}"
anoncvs="${anoncvs:-anoncvs@openbsd.nycbug.org:/cvs}"
pkgs="${pkgs:-{tor-*.tgz,torsocks-*.tgz}"
tz="${tz:-UTC}"
# be br cf de dk es fr hu is it jp la lt lv nl no pl pt ru sf sg si sv tr ua uk us
locale="${locale:-us}"
dns="${dns:-198.6.1.6}"
hostname="${hostname:-flashrd-$now-$sysver}"
conf="${conf:-$HOME/flrd-conf}"
#passwd="${passwd:-passwd}"

#die(){
#	echo >&2 "ERROR:" "$@"
#	exit 1
#	}

/etc/rc.d/tor restart;

# cleanup

/sbin/vnconfig -u /dev/vnd[0-4]

rm $flashrdpath/flashimg.i386-$now;

rm $flashrdpath/base$sysver.tgz;

rm $flashrdpath/SHA256.sig;

cd $buildpath;

rm -rf $buildpath && mkdir -p $buildpath;

cd $flashrdpath;

ftp -ai $mirror/$arch/{base$sysver.tgz,SHA256.sig};

/usr/bin/signify -C -p /etc/signify/openbsd-$sysver-base.pub -x SHA256.sig base$sysver.tgz;

tar zxpf $flashrdpath/base$sysver.tgz -C $buildpath;

#tar zxpf $buildpath/usr/share/sysmerge/etc.tgz -C $buildpath;

mkdir -p $flashrdpath/PACKAGES;

#cat $flashrdpath/rc.conf.local >>$flashrdpath/etc/rc.flashrd.local;
cat $flashrdpath/rc.conf.local >>$buildpath/etc/rc.flashrd.local;

cp -R $conf/* $buildpath;

cp $conf/root/.profile $buildpath;

cp $conf/root/.profile $buildpath/root;

#echo '/sbin/swapctl -a /flash/swap0'>>$buildpath/etc/rc.flashrd.local;

#echo '/flash/swap0 /flash/swap0 swap sw 0 0' >>$buildpath/etc/fstab;

#chmod 0755 $flashrdpath/etc/rc.flashrd.local;

# Get packages for /etc/rc.flashrd.onetime install

#cd $buildpath/PACKAGES;

#ftp -iva $mirror/$ver/packages/$arch/$pkgs;

# cvs, assuming CVSROOT already defined in /usr/src

cd /usr/src;

#cvs -d $anoncvs get -OPENBSD_5_8 src;

#cvs -d $anoncvs up -Pd;

#cvs up -Pd;

# deal with DMA errors with 0x0ff0 flags at wd*

#cp $flashrdpath/FLASHRD /usr/src/sys/arch/i386/conf/

cd $flashrdpath && torsocks git pull;

#/etc/rc.d tor stop;

./flashrd $buildpath;

# reconfigure a bunch of settings and build image

./cfgflashrd -k $locale -ntp "pool.ntp.org" -t $tz -dns $dns -hostname $hostname -image $flashrdpath/flashimg.$arch-$now -com0 38400;

#how to make $passwd and enter 2x?
#read -p "Password:" $passwd;

echo "Now write with 'cd $flashrdpath && ./growimg -t sdX $flashrdpath/flashimg.$arch-$now'"
