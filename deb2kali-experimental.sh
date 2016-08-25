#!/bin/bash 

### Replace the Debian repos with Kali repos ###
mv /etc/apt/sources.list /etc/apt/sources.list.debian
cat <<EOF > /etc/apt/sources.list
# deb cdrom:[Debian GNU/Linux 2.0 _Sana_ - Official Snapshot amd64 LIVE/INSTALL Binary 20150811-04:39]/ sana contrib main non-free

deb http://http.kali.org/kali sana main non-free contrib
deb-src http://http.kali.org/kali sana main non-free contrib

deb http://security.kali.org/kali-security/ sana/updates main contrib non-free
deb-src http://security.kali.org/kali-security/ sana/updates main contrib non-free
EOF

### Add the Kali Linux GPG keys to aptitude ###
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ED444FF07D8D0BF6

### Update and install base packages ###
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove --purge

# Next four lines commented out for experimental version 
#apt-get -y install kali-linux

### Downgrade specific packages to their Kali Linux versions ###
#apt-get -y --force-yes install tzdata=2015d-0+deb8u1
#apt-get -y --force-yes install libc6=2.19-18
#apt-get -y --force-yes install systemd=215-17+deb8u1 libsystemd0=215-17+deb8u1

fix_depends() {

target=$1

output=$(echo n | apt-get install $target 2>/dev/null | grep -A100 'unmet dependencies')

# Make for loop iterate over lines, not spaces
IFS=$(echo -en "\n\b")

for l in $(echo "$output" | grep 'Depends:'); do
    next_pkg=$(echo $l | cut -d ':' -f 3)
    if [ "$(echo $next_pkg | grep -o 'is not going to be installed')" == "is not going to be installed" ] ; then
        new_target=$(echo $next_pkg | cut -d ':' -f 3 | cut -d ' ' -f 2)
        echo Next package: $new_target
        fix_depends $new_target
    else
        echo Installing dependencies...
        name=$(echo $next_pkg | cut -d ' ' -f 2)
        version=$(echo $next_pkg | cut -d '=' -f 2 | cut -d ')' -f 1 | tr -d ' ' )
        apt-get -y --force-yes install $name=$version

    fi

done

}

fix_depends kali-linux

apt-get -y install kali-linux

### Double-check that nothing else needs to be updated ###
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade

### Clean up ###
apt-get -y autoremove --purge
apt-get clean
echo Done.
