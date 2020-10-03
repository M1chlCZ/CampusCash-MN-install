#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -a|--advanced)
    ADVANCED="y"
    shift
    ;;
    -n|--normal)
    ADVANCED="n"
    FAIL2BAN="y"
    UFW="y"
    BOOTSTRAP="y"
    shift
    ;;
    -i|--externalip)
    EXTERNALIP="$2"
    ARGUMENTIP="y"
    shift
    shift
    ;;
    -k|--privatekey)
    KEY="$2"
    shift
    shift
    ;;
    -f|--fail2ban)
    FAIL2BAN="y"
    shift
    ;;
    --no-fail2ban)
    FAIL2BAN="n"
    shift
    ;;
    -u|--ufw)
    UFW="y"
    shift
    ;;
    --no-ufw)
    UFW="n"
    shift
    ;;
    -b|--bootstrap)
    BOOTSTRAP="y"
    shift
    ;;
    --no-bootstrap)
    BOOTSTRAP="n"
    shift
    ;;
    -s|--swap)
    SWAP="y"
    shift
    ;;
    --no-swap)
    SWAP="n"
    shift
    ;;
    -h|--help)
    cat << EOL
CBN Masternode installer arguments:
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
    *)    # unknown option
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
apt-get install git dnsutils systemd -y > /dev/null 2>&1

# Check for systemd
systemctl --version >/dev/null 2>&1 || { echo "systemd is required. Are you using Ubuntu 16.04?"  >&2; exit 1; }

# Getting external IP
if [ -z "$EXTERNALIP" ]; then
    EXTERNALIP=`dig +short myip.opendns.com @resolver1.opendns.com`
fi
clear

if [ -z "$ADVANCED" ]; then

cat << "EOF" 
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
    USER=ccash

    adduser $USER --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

    INSTALLERUSED="#Used Advanced Install"

    echo "" && echo 'Added user "ccash"' && echo ""
    sleep 1
else
    USER=root
    UFW="y"
    INSTALLERUSED="#Used Basic Install"
fi

USERHOME=`eval echo "~$USER"`

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




clear

# Generate random passwords
RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo "Configuring swap file..."
# Configuring SWAPT
if [[ ("$SWAP" == "y" || "$SWAP" == "Y" || "$SWAP" == "") ]]; then
    cd ~
    sudo fallocate -l 3G /swapfile
    ls -lh /swapfile
    sudo chmod 600 /swapfile
    ls -lh /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo swapon --show
    sudo cp /etc/fstab /etc/fstab.bak
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi
clear

# update packages and upgrade Ubuntu
echo "Installing dependencies..."
apt-get update 
apt-get upgrade -y
apt-get -qq -y install ntp build-essential libssl-dev libdb-dev libdb++-dev libboost-all-dev libqrencode-dev libcurl4-openssl-dev curl libzip-dev
apt-get -qq -y install make automake build-essential libboost-all-dev yasm binutils libcurl4-openssl-dev openssl libgmp-dev libtool libssl-dev
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
git clone https://github.com/SaltineChips/CampusCash CampusCash
cd ~/CampusCash/src
chmod a+x obj
chmod a+x leveldb/build_detect_platform
chmod a+x secp256k1
chmod a+x leveldb
chmod a+x ~/CampusCash/src
chmod a+x ~/CampusCash
make -f makefile.unix USE_UPNP=-
cd ~ 
cp  CampusCash/src/CampusCashd /root/Campusd
rm -r CampusCash


# Create CCASH directory
mkdir /root/.CCASH


# Create CampusCash.conf
touch /root/.CCASH/CampusCash.conf
cat > /root/.CCASH/CampusCash.conf << EOL
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
addnode=45.77.210.8:19427
addnode=45.77.210.8
addnode=45.77.210.234:19427
addnode=45.77.210.234
addnode=192.168.1.14:19427
addnode=192.168.1.14
addnode=104.238.156.128:19427
addnode=104.238.156.128
addnode=66.42.71.176:19427
addnode=66.42.71.176
addnode=110.109.107.71:19427
addnode=110.109.107.71
addnode=82.165.119.20:19427
addnode=82.165.119.20
addnode=82.165.115.26:19427
addnode=82.165.115.26
addnode=217.160.29.63:19427
addnode=217.160.29.63
addnode=138.197.161.183:19427
addnode=138.197.161.183
addnode=157.230.107.144:19427
addnode=157.230.107.144
addnode=137.220.34.237:19427
addnode=137.220.34.237
addnode=184.166.67.221: 19427
addnode=184.166.67.221
addnode=167.99.88.37:19427
addnode=167.99.88.37
addnode=104.131.5.21:36318
addnode=110.232.115.241:19427
addnode=115.64.195.144:62696
addnode=144.202.84.166:19427
addnode=146.115.33.63:60838
addnode=153.156.116.4:10886
addnode=155.138.148.198:35126
addnode=159.203.186.121:19427
addnode=161.35.231.193:19427
addnode=167.99.88.37:19427
addnode=185.52.172.164:58910
addnode=27.3.0.244:56733
addnode=64.225.122.213:19427
addnode=72.190.77.61:49737
addnode=72.190.77.61:53797
addnode=77.242.107.120:54374
addnode=87.166.116.52:61296
addnode=89.1.209.121:38139
addnode=89.216.28.76:50571
addnode=93.233.193.196:26900
addnode=95.179.169.186:59288
EOL
chmod 0600 /root/.CCASH/CampusCash.conf
chown -R $USER:$USER /root/.CCASH

sleep 1

cat > /etc/systemd/system/ccash.service << EOL
[Unit]
Description=CCASHD
After=network.target
[Service]
Type=forking
User=${USER}
WorkingDirectory=/root/
ExecStart=/root/Campusd -conf=/root/.CCASH/CampusCash.conf -datadir=/root/.CCASH
ExecStop=/root/Campusd -conf=/root/.CCASH/CampusCash.conf -datadir=/root/.CCASH
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOL
sudo systemctl daemon-reload
sudo systemctl enable ccash.service
sudo systemctl start ccash.service

clear

echo "Setting up CCASH daemon..."
cat > /etc/systemd/system/ccash.service << EOL
[Unit]
Description=CCASHD
After=network.target
[Service]
Type=forking
User=${USER}
WorkingDirectory=/root/
ExecStart=/root/Campusd -conf=/root/.CCASH/CampusCash.conf -datadir=/root/.CCASH
ExecStop=/root/Campusd -conf=/root/.CCASH/CampusCash.conf -datadir=/root/.CCASH
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOL

clear

cat << EOL
Now, you need to wait for sync you can check the progress by typing getinfo. After full sync please go to your desktop wallet
Click the Masternodes tab
Click Start all at the bottom
EOL

read -p "Press Enter to continue after read to continue. " -n1 -s

cat << EOL
After full sync block with getinfo = blocks you see in your local wallet (right down corner, however mouse over check sign)
Type: mnstart
EOL

read -p "Press Enter to continue after read to continue. " -n1 -s

clear

rm -rf /root/ccashMNinstall.sh
wget https://raw.githubusercontent.com/M1chlCZ/CampusCash-MN-install/main/env.sh 
chmod +x env.sh
./env.sh
rm -r env.sh 
. ~/.profile
echo "" && echo "Masternode setup complete" && echo ""

