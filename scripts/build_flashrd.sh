#!/bin/sh -x
# $arch and $ver has to match the build box right now
# for building a basic image

now="${now:-`date "+%Y%m%d"`}"
ver="${ver:-`uname -r`}"
sysver="${sysver:-`uname -r | tr -d "."`}"
# i386 supports both Soekris and Alix boards
arch="${arch:-`uname -m`}"
#mach="${mach:-ALIX}"
flashrdpath="${flashrdpath:-$HOME/flashrd}"
source="${source:-$HOME/openbsd}"
mirror="${mirror:-ftp://mirrors.nycbug.org/pub/OpenBSD/$ver/$arch}"
anoncvs="${anoncvs:-anoncvs@openbsd.nycbug.org:/cvs}"
sets="${sets:-{bsd,bsd.rd,SHA256.sig,base$sysver.tgz}}"
tz="${tz:-UTC}"
# be br cf de dk es fr hu is it jp la lt lv nl no pl pt ru sf sg si sv tr ua uk us
locale="${locale:-us}"
dns="${dns:-198.6.1.6}"
hostname="${hostname:-flashrd-$now-$sysver}"

# stop me if it's gets ugly

die(){
	echo >&2 "ERROR:" "$@"
	exit 1
	}

# cleanup the previous mess from today

/sbin/vnconfig -u /dev/vnd{0-4}

cd $HOME;

rm $flashrdpath/flashimg.i386-$now;

rm -rf $source/*;

# grab and extract the source

cd $source;

ftp -ai $mirror/$sets;

/usr/bin/signify -C -p /etc/signify/openbsd-$sysver-base.pub -x $sets;

tar zxpf base$sysver.tgz;

tar zxpf var/sysmerge/etc.tgz;

#mkdir -p $flashrdpath/PACKAGES;

#cat $flashrdpath/rc.conf.local >>$flashrdpath/etc/rc.flashrd.local;
#cat $flashrdpath/rc.conf.local >>$buildpath/etc/rc.flashrd.local;

echo 'sndiod_flags=NO\nntpd_flags="-s"\nsmtpd_flags=NO\nhttpd_flags=""' >$source/etc/rc.conf.local;

#cp -R $conf/* $buildpath;

#cp $conf/root/.profile $buildpath;

#cp $conf/root/.profile $buildpath/root;

#echo '/sbin/swapctl -a /flash/swap0'>>$buildpath/etc/rc.flashrd.local;

#echo "/flash/swap0 /flash/swap0 swap sw 0 0" >>$buildpath/etc/fstab;

#chmod 0755 $flashrdpath/etc/rc.flashrd.local;

# Get packages for /etc/rc.flashrd.onetime install

#cd $buildpath/PACKAGES;

#ftp -iva $mirror/$ver/packages/$arch/$pkgs;

# cvs, assuming CVSROOT Root already defined in /usr/src

#cd /usr/src && cvs up -Pd;

#SOEKRIS deal with DMA errors with 0x0ff0 flags at wd*

#cp $flashrdpath/FLASHRD /usr/src/sys/arch/i386/conf/

#cd $flashrdpath && torsocks git pull;

#/etc/rc.d tor stop;

cd $flashrdpath && /bin/sh flashrd $source;

# reconfigure a bunch of settings and build image

./cfgflashrd -k $locale -ntp "pool.ntp.org" -t $tz -dns $dns -hostname $hostname -image $flashrdpath/flashimg.$arch-$now -com0 9600;

# root passwd prompt

echo "Now write with 'cd $flashrdpath && ./growimg -t diskN $flashrdpath/flashimg.$arch-$now'"

true
