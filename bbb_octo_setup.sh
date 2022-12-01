#!/bin/bash
# ----------------------------------DEFINE----------------------------------------
# DEFINES
CLEAR="\e[0m"
BOLD="\e[1m"
UNDERLINE="\e[4m"
BLINK="\e[5m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
BG_RED="\e[41m"
BG_GREEN="\e[42m"
BG_YELLOW="\e[43m"
BG_BLUE="\e[44m"
BG_MAGENTA="\e[45m"
BG_CYAN="\e[46m"
# -------------------------------------START---------------------------------------
function print(){
    if [[ "$#" == 1 ]]; then
        echo -e "$MAGENTA $1 $CLEAR"
    else
        echo -e "$1 $2 $CLEAR"
    fi
}

function print_warning(){
    if [[ "$#" == 1 ]]; then
        echo -e "$YELLOW Warning: $1 $CLEAR"
    else
        echo -e "$1 $2 $CLEAR"
    fi
}

function print_error(){
    if [[ "$#" == 1 ]]; then
        echo -e "$RED Error: $1 $CLEAR"
    else
        echo -e "$1 $2 $CLEAR"
    fi
}

# Download Debian 10 image for BBB
# https://debian.beagleboard.org/images/bone-debian-10.3-iot-armhf-2020-04-06-4gb.img.xz
# Write image to micro SD card
# Power up BBB and connect to PC using micro USB cable
# Open start .html file and check for local IP. default: 192.168.7.2
# ssh debian@192.168.7.2
# username: debian
# default password: temppwd

# Optional:
# Check debian version:
# >>> lsb_release -a

# setup wifi
# Scan for services
# >>> sudo connmanctl
# >>> enable wifi
# >>> scan wifi
# If the system doesn’t response “Scan completed for wifi” then we need to disable wifi and enable again
# View list of services:
# >>> services 
# Connect to wifi:
# >>> agent on
# >>> connect wifit_aldjaoigjoiasgjiaogfioa (COPY and PASTE here)
# Provide wifi password
# >>> quit
# >>> ping www.google.com

# Download this script at 
# wget https://raw.githubusercontent.com/luutp/luuNotes/develop/src/bbb_octo_setup.sh?token=GHSAT0AAAAAABY3QIGO6PXXFJEAVNH4EN62YZE6V4Q -O bbb_octo_setup.sh
# Run bash file
# >>> bash bbb_octo_setup.sh

print "Step 1/5: sudo apt-get update"
sudo apt-get update
# Install python 3
print "Step 2/5: Install Python 3"
sudo apt install -y python3-pip python3-dev python3-setuptools python3-venv git libyaml-dev build-essential
# Create OctoPrint dir
print "mkdir OctoPrint && cd OctoPrint"
mkdir OctoPrint && cd OctoPrint
sudo chown -R debian ~/OctoPrint
# Create new venv
print "Step 3/5: create new venv and install octoprint"
python3 -m venv venv
source ~/OctoPrint/venv/bin/activate
# Upgrade pip and install octoprint
print "Upgrade pip and install octoprint"
yes | /home/debian/OctoPrint/venv/bin/pip install pip --upgrade
yes | /home/debian/OctoPrint/venv/bin/pip install octoprint
# add the debian user to the dialout group and tty so that the user can access the serial ports, before starting OctoPrint
print "Step 4/5: Enable Serial Connection"
sudo usermod -a -G tty debian
sudo usermod -a -G dialout debian
# Add automatic start up
print "Step 5/5: Enable octoprint at start up"
wget https://raw.githubusercontent.com/luutp/luuNotes/develop/src/octoprint.service?token=GHSAT0AAAAAABY3QIGOCPRQDI2QRATMQYQYY2SEG2A -O octoprint.service
sudo mv octoprint.service /etc/systemd/system/octoprint.service
sudo systemctl enable octoprint.service
print "DONE"
# Restart BBB
# Run octoprint service
# sudo service octoprint {start|stop|restart}
# sudo shutdown -r now
# Scan for BBB IP address. e.g., angry IP scanner