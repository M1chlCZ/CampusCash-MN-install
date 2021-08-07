#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    -a | --advanced)
        ADVANCED="y"
        shift
        ;;
    -n | --normal)
        ADVANCED="n"
        FAIL2BAN="y"
        UFW="y"
        BOOTSTRAP="y"
        shift
        ;;
    -i | --externalip)
        EXTERNALIP="$2"
        ARGUMENTIP="y"
        shift
        shift
        ;;
    -k | --privatekey)
        KEY="$2"
        shift
        shift
        ;;
    -f | --fail2ban)
        FAIL2BAN="y"
        shift
        ;;
    --no-fail2ban)
        FAIL2BAN="n"
        shift
        ;;
    -u | --ufw)
        UFW="y"
        shift
        ;;
    --no-ufw)
        UFW="n"
        shift
        ;;
    -b | --bootstrap)
        BOOTSTRAP="y"
        shift
        ;;
    --no-bootstrap)
        BOOTSTRAP="n"
        shift
        ;;
    -s | --swap)
        SWAP="y"
        shift
        ;;
    --no-swap)
        SWAP="n"
        shift
        ;;
    -h | --help)
        cat <<EOL
CCASH Masternode installer arguments:
    -n --normal               : Run installer in normal mode
    -a --advanced             : Run installer in advanced mode
    -i --externalip <address> : Public IP address of VPS
    -k --privatekey <key>     : Private key to use
    -f --fail2ban             : Install Fail2Ban
    --no-fail2ban             : Don't install Fail2Ban
    -u --ufw                  : Install UFW
    --no-ufw                  : Don't install UFW
    -b --bootstrap            : Sync node using Bootstrap
    --no-bootstrap            : Don't use Bootstrap
    -h --help                 : Display this help text.
    -s --swap                 : Create swap for <2GB RAM
EOL
        exit
        ;;
    *)                     # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

clear

# Check if we are root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root! Aborting..." 1>&2
    exit 1
fi

# Install tools for dig and systemctl
echo "Preparing installation..."
apt-get install git dnsutils systemd -y >/dev/null 2>&1
killall Campusd >/dev/null 2>&1

# Check for systemd
systemctl --version >/dev/null 2>&1 || {
    echo "systemd is required. Are you using Ubuntu 16.04?" >&2
    exit 1
}

# Getting external IP
if [ -z "$EXTERNALIP" ]; then
    EXTERNALIP=$(dig +short myip.opendns.com @resolver1.opendns.com)
fi
clear

if [ -z "$ADVANCED" ]; then

    cat <<"EOF"
  _____                         _____         __     __  ____  __  ____    __          
 / ___/__ ___ _  ___  __ _____ / ___/__ ____ / /    /  |/  / |/ / / __/__ / /___ _____ 
/ /__/ _ `/  ' \/ _ \/ // (_-</ /__/ _ `(_-</ _ \  / /|_/ /    / _\ \/ -_) __/ // / _ \
\___/\_,_/_/_/_/ .__/\_,_/___/\___/\_,_/___/_//_/ /_/  /_/_/|_/ /___/\__/\__/\_,_/ .__/
              /_/                                                               /_/   
EOF

    echo "

     +---------MASTERNODE INSTALLER v1 ---------+
 |                                                  |
 | You can choose between two installation options: |::
 |              default and advanced.               |::
 |                                                  |::
 |  The advanced installation will install and run  |::
 |   the masternode under a non-root user. If you   |::
 |   don't know what that means, use the default    |::
 |               installation method.               |::
 |                                                  |::
 |  Otherwise, your masternode will not work, and   |::
 |    the CampusCASH Team WILL NOT assist you in    |::
 |                 repairing it.                    |::
 |                                                  |::
 |           You will have to start over.           |::
 |                                                  |::
 +--------------------------------------------------+
 ::::::::::::::::::::::::::::::::::::::::::::::::::::

"

    sleep 5
fi

if [ -z "$ADVANCED" ]; then
    read -e -p "Use the Advanced Installation? [N/y] : " ADVANCED
fi

if [[ ("$ADVANCED" == "y" || "$ADVANCED" == "Y") ]]; then
    USER=root
    INSTALLERUSED="#Used Advanced Install"

    echo "" && echo 'Using advance install' && echo ""
    sleep 1
else
    USER=root
    UFW="y"
    INSTALLERUSED="#Used Basic Install"
    BOOTSTRAP="y"
fi

USERHOME=$(eval echo "~$USER")

if [ -z "$KEY" ]; then
    read -e -p "Masternode Private Key : " KEY
fi

if [ -z "$SWAP" ]; then
    read -e -p "Does VPS use less than 2GB RAM? [Y/n] : " SWAP
fi

if [ -z "$UFW" ]; then
    read -e -p "Install UFW and configure ports? [Y/n] : " UFW
fi

if [ -z "$ARGUMENTIP" ]; then
    read -e -p "Server IP Address: " -i $EXTERNALIP -e IP
fi

if [ -z "$BOOTSTRAP"]; then
    read -e -p "Download bootstrap for fast sync? [Y/n] : " BOOTSTRAP
fi

clear

# Generate random passwords
RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo "Configuring swap file..."
# Configuring SWAPT
if [[ ("$SWAP" == "y" || "$SWAP" == "Y" || "$SWAP" == "") ]]; then
    cd ~
    sudo swapoff -a
    sudo dd if=/dev/zero of=/swapfile bs=6144 count=1048576
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
fi
clear

# update packages and upgrade Ubuntu
echo "Installing dependencies..."
apt-get update
apt-get upgrade -y
apt-get -qq -y install ntp build-essential libssl-dev libdb-dev libdb++-dev libboost-all-dev libqrencode-dev libcurl4-openssl-dev curl libzip-dev
apt-get -qq -y install make automake build-essential libboost-all-dev yasm binutils libcurl4-openssl-dev openssl libgmp-dev libtool libssl-dev unzip
clear

echo "Configuring UFW..."
# Install UFW
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
    apt-get -qq install ufw
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow 19427/tcp
    yes | ufw enable
fi
clear

# Install Berkley DB 5.6
echo "Installing Berkley DB..."
cd ~
wget http://download.oracle.com/berkeley-db/db-6.2.32.NC.tar.gz
tar zxf db-6.2.32.NC.tar.gz
cd db-6.2.32.NC/build_unix
../dist/configure --enable-cxx --disable-shared
make
make install
ln -s /usr/local/BerkeleyDB.6.2/lib/libdb-6.2.so /usr/lib/libdb-6.2.so
ln -s /usr/local/BerkeleyDB.6.2/lib/libdb_cxx-6.2.so /usr/lib/libdb_cxx-6.2.so
export BDB_INCLUDE_PATH="/usr/local/BerkeleyDB.6.2/include"
export BDB_LIB_PATH="/usr/local/BerkeleyDB.6.2/lib"
cd ~
rm db-6.2.32.NC.tar.gz
rm -r db-6.2.32.NC

# Install CCASH daemon
cd ~
wget https://github.com/CampusCash/CampusCash_Core/releases/download/1.1.0.4/Campusd.zip
unzip Campusd.zip
rm Campusd.zip

clear

# Create CCASH directory
mkdir /root/.CCASH

# Bootstrap
if [[ ("$BOOTSTRAP" == "y" || "$BOOTSTRAP" == "Y" || "$BOOTSTRAP" == "") ]]; then
    echo "Downloading bootstrap..."
    cd ~/.CCASH
    wget https://bootstrap.campuscash.org/boot_strap.zip
    unzip boot_strap.zip
    rm boot_strap.zip
    cd ~
fi

# Create CampusCash.conf
touch ~/.CCASH/CampusCash.conf
cat >~/.CCASH/CampusCash.conf <<EOL
${INSTALLERUSED}
rpcuser=${RPCUSER}
rpcpassword=${RPCPASSWORD}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
logips=1
externalip=${IP}
bind=${IP}:19427
masternodeaddr=${IP}:19427
masternodeprivkey=${KEY}
masternode=1
addnode = 185.52.172.164: 19427
addnode = 185.52.172.164
addnode = 91.132.144.89: 19427
addnode = 91.132.144.89
addnode = 46.101.247.122: 19427
addnode = 46.101.247.122
addnode = 143.198.130.185: 19427
addnode = 143.198.130.185
addnode = 202.61.254.25:19427
addnode = 202.61.254.25
addnode = 185.220.101.132:19427
addnode = 185.220.101.132
addnode = 45.32.189.107:19427
addnode = 45.32.189.107
addnode = 45.76.121.100:19427
addnode = 45.76.121.100
EOL
chmod 0600 ~/.CCASH/CampusCash.conf
chown -R $USER:$USER ~/.CCASH

sleep 1
clear

#Set up enviroment variables
cd ~

wget https://raw.githubusercontent.com/M1chlCZ/CampusCash-MN-install/main/env.sh
source env.sh
source ~/.profile

clear

echo "Setting up CCASH daemon..."
cat >/etc/systemd/system/ccash.service <<EOL
[Unit]
Description=CCASHD
After=network.target
[Service]
Type=forking
User=${USER}
WorkingDirectory=/root/
ExecStart=/root/Campusd -conf=/root/.CCASH/CampusCash.conf -datadir=/root/.CCASH
ExecStop=/root/Campusd -conf=/root/.CCASH/CampusCash.conf -datadir=/root/.CCASH stop
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOL
sudo systemctl daemon-reload
sudo systemctl enable ccash.service
sudo systemctl start ccash.service

clear

cat <<EOL
Now, you need to wait for sync you can check the progress by typing getinfo. After full sync please go to your desktop wallet
Click the Masternodes tab
Click Start all at the bottom

If for some reason commands such as mnstart, mnstatus, getinfo did not work, please log out of this session and log back in.

EOL

read -p "Press Enter to continue after read to continue. " -n1 -s
clear

#File cleanup
rm -r ~/CampusCash
rm -rf ~/ccashMNinstall.sh

echo "" && echo "Masternode setup complete" && echo ""

cat <<"EOF"
           |Brought to you by|         
  __  __ _  ____ _   _ _     ____ _____
 |  \/  / |/ ___| | | | |   / ___|__  /
 | |\/| | | |   | |_| | |  | |     / / 
 | |  | | | |___|  _  | |__| |___ / /_ 
 |_|  |_|_|\____|_| |_|_____\____/____|
       For complains Tweet @M1chl 

CCASH: Ccbbd6uUZF2GD5wE5LEfjGPA3YWPjoLC6P

EOF
