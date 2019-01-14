# deb2kali
A Script to Convert Debian Linux (8.1) into Kali Linux

Usage (as root):

    apt-get update && apt-get -y install git
    cd /opt
    git clone https://github.com/Wh1t3Rh1n0/deb2kali
    bash deb2kali/deb2kali.sh

Afterward, you can either install individual tools one by one or install them all with:

    apt-get -y install kali-linux-full

# Added Features
Added a pre-start warning if the script isn't being run as root.
Added git to pre-installation packages
Changed from using 'apt-get' to 'apt' so installation progress is easier to follow.
Added an optional command-line argument 'full' to install kali-linux-full instead of kali-linux.
