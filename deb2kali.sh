#!/bin/bash -v

if [ "$(whoami)" != "root" ]; then
    echo "***"
    echo "*** This script needs to be run as root or inconjunction with the sudo command!"
    echo "***"
fi

### Install needed packages
apt update
apt -y install dirmngr git

### Add the Kali Linux GPG keys to aptitude ###
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ED444FF07D8D0BF6

### Replace the Debian repos with Kali repos ###
mv /etc/apt/sources.list /etc/apt/sources.list.debian
cat <<EOF > /etc/apt/sources.list
deb http://http.kali.org/kali kali-rolling main non-free contrib
# deb-src http://http.kali.org/kali kali-rolling main non-free contrib
EOF

### Default to installing the base kali system or do a full install if requested
### It should be noted doing a "full" install does not install X windows
PACKAGE="kali-linux"
if [ "$1" == "full" ]; then PACKAGE="kali-linux-full"; fi

### Update and install base packages ###
apt update
apt -y upgrade
apt -y dist-upgrade
apt -y autoremove --purge
apt -y install $PACKAGE

### Downgrade specific packages to their Kali Linux versions ###
### * Commented out since this is currently no longer necessary (2017-09-17).
###   Leaving it for future reference just in case.
#apt-get -y --force-yes install tzdata=2015d-0+deb8u1
#apt-get -y --force-yes install libc6=2.19-18
#apt-get -y --force-yes install systemd=215-17+deb8u1 libsystemd0=215-17+deb8u1
#
### Double-check that nothing else needs to be updated ###
#apt-get update
#apt-get -y upgrade
#apt-get -y dist-upgrade

### Clean up ###
apt -y autoremove --purge
apt clean
echo Done.
