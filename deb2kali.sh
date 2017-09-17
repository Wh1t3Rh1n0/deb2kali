#!/bin/bash -v

### Install needed packages
apt-get update
apt-get install -y dirmngr

### Add the Kali Linux GPG keys to aptitude ###
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ED444FF07D8D0BF6

### Replace the Debian repos with Kali repos ###
mv /etc/apt/sources.list /etc/apt/sources.list.debian
cat <<EOF > /etc/apt/sources.list
deb http://http.kali.org/kali kali-rolling main non-free contrib
# deb-src http://http.kali.org/kali kali-rolling main non-free contrib
EOF

### Update and install base packages ###
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove --purge
apt-get -y install kali-linux

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
apt-get -y autoremove --purge
apt-get clean
echo Done.
