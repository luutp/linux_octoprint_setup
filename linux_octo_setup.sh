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

# Install ubuntu 20.04 with Python 3.8 as default
# Update 
# >>> sudo apt install update
# Install openssh-server
# >>> sudo apt install openssh-server
# Connect via ssh

# Download this script at 
# wget https://raw.githubusercontent.com/luutp/linux_octoprint_setup/master/linux_octo_setup.sh -O octo_setup.sh
# Run bash file
# >>> bash octo_setup.sh

USER=octo

print "Step 1/5: sudo apt-get update"
sudo apt-get update
# Install python 3.7
print "Step 2/5: Install Python 3"
sudo apt install -y python3-pip python3-dev python3-setuptools python3-venv git libyaml-dev build-essential
# Create OctoPrint dir
print "mkdir OctoPrint && cd OctoPrint"
mkdir OctoPrint && cd OctoPrint
sudo chown -R octo ~/OctoPrint
# Create new venv
print "Step 3/5: create new venv and install octoprint"
python3 -m venv venv
source ~/OctoPrint/venv/bin/activate
# Upgrade pip and install octoprint
print "Upgrade pip and install octoprint"
yes | /home/${USER}/OctoPrint/venv/bin/pip install --upgrade pip
yes | /home/${USER}/OctoPrint/venv/bin/pip install octoprint
# add the debian user to the dialout group and tty so that the user can access the serial ports, before starting OctoPrint
print "Step 4/5: Enable Serial Connection"
sudo usermod -a -G tty ${USER}
sudo usermod -a -G dialout ${USER}
# Add automatic start up
print "Step 5/5: Enable octoprint at start up"
wget https://raw.githubusercontent.com/luutp/linux_octoprint_setup/master/octo_octoprint.service -O octoprint.service
sudo mv octoprint.service /etc/systemd/system/octoprint.service
sudo systemctl enable octoprint.service
print "DONE"
# Restart BBB
# Run octoprint service
# sudo service octoprint {start|stop|restart}
# sudo service octoprint start
# sudo shutdown -r now
# Scan for BBB IP address. e.g., angry IP scanner
