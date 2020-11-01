echo "Setting up enviromental commands..."
cd ~

rm /root/.commands/gethelp > /dev/null 2>&1
rm /root/.commands/getinfo > /dev/null 2>&1
rm /root/.commands/mnstart > /dev/null 2>&1
rm /root/.commands/mnstatus > /dev/null 2>&1
rm /root/.commands/startd > /dev/null 2>&1
rm /root/.commands/stopd > /dev/null 2>&1
rm /root/.commands/commandUpdate > /dev/null 2>&1
rm /root/.commands/campusUpdate > /dev/null 2>&1
rm /root/.commands/clearbanned > /dev/null 2>&1
rm /root/.commands/getBootstrap > /dev/null 2>&1

cat > ~/.commands/gethelp << EOL
#!/bin/bash

cat << "EOF"
          |Brought to you by|         
  __  __ _  ____ _   _ _     ____ _____
 |  \/  / |/ ___| | | | |   / ___|__  /
 | |\/| | | |   | |_| | |  | |     / / 
 | |  | | | |___|  _  | |__| |___ / /_ 
 |_|  |_|_|\____|_| |_|_____\____/____|
       For complains Tweet @M1chl 

CCASH: Ccbbd6uUZF2GD5wE5LEfjGPA3YWPjoLC6P

EOF
echo ""
echo "Here is list of commands for you CampusCash service"
echo "you can type these commands anywhere in terminal."
echo ""
echo "Command              | What does it do?"
echo "---------------------------------------------------"
echo "getinfo              | Get wallet info"
echo ""
echo "mnstart              | Start masternode"
echo ""
echo "mnstatus             | Status of the masternode"
echo ""
echo "startd               | Start CampusCash deamon"
echo ""
echo "stopd                | Stop CampusCash deamon"
echo ""
echo "campusUpdate         | Update CampusCash deamon"
echo ""
echo "commandUpdate        | Update List of commands"
echo ""
echo "getBootstrap         | Get a bootstrap"
echo ""
echo "getpeerinfo          | Show peer info"
echo ""
echo "clearbanned          | Clear all banned IPs"
echo ""
echo "gethelp              | Show help"
echo "---------------------------------------------------"
echo ""

EOL

cat > ~/.commands/getinfo << EOL
#!/bin/bash    
~/Campusd getinfo
EOL

cat > ~/.commands/getpeerinfo << EOL
#!/bin/bash    
~/Campusd getpeerinfo
EOL

cat > ~/.commands/mnstart << EOL
#!/bin/bash    
~/Campusd masternode start
EOL

cat > ~/.commands/mnstatus << EOL
#!/bin/bash    
~/Campusd masternode status
EOL

cat > ~/.commands/startd << EOL
#!/bin/bash
systemctl start ccash.service > /dev/null 2>&1
echo "CampusCash Deamon is running..."
EOL

cat > ~/.commands/stopd << EOL
#!/bin/bash
systemctl stop ccash.service
sleep 1
if pgrep Campusd &> /dev/null ; then killall Campusd > /dev/null 2>&1 ; fi
echo "CampusCash Deamon is innactive..."
EOL

cat > ~/.commands/clearbanned << EOL
#!/bin/bash    
~/Campusd clearbanned
EOL

cat > ~/.commands/getBootstrap << EOL
systemctl stop ccash.service 
killall Campusd > /dev/null 2>&1

cd ~

mv /root/.CCASH/CampusCash.conf CampusCash.conf
mv /root/.CCASH/wallet.dat wallet.dat

apt-get install -y unzip
cd ~/.CCASH
rm -rf *
wget https://github.com/SaltineChips/CampusCash/releases/download/1.0.0.0/CCASH_bootstrap.zip;
unzip CCASH_bootstrap.zip
rm CCASH_bootstrap.zip
cd ~

mv CampusCash.conf /root/.CCASH/CampusCash.conf
mv wallet.dat /root/.CCASH/wallet.dat

systemctl start ccash.service > /dev/null 2>&1
echo "CampusCash Deamon is running..."
EOL

cat > ~/.commands/commandUpdate << EOL
#!/bin/bash
cd ~ 
wget https://raw.githubusercontent.com/M1chlCZ/CampusCash-MN-install/main/env.sh > /dev/null 2>&1
source env.sh
clear

cat << "EOF"
            Update complete!

           |Brought to you by|         
  __  __ _  ____ _   _ _     ____ _____
 |  \/  / |/ ___| | | | |   / ___|__  /
 | |\/| | | |   | |_| | |  | |     / / 
 | |  | | | |___|  _  | |__| |___ / /_ 
 |_|  |_|_|\____|_| |_|_____\____/____|
       For complains Tweet @M1chl 

CCASH: Ccbbd6uUZF2GD5wE5LEfjGPA3YWPjoLC6P

EOF

. ~/.commands/gethelp

echo ""
EOL

cat > ~/.commands/campusUpdate << EOL
#!/bin/bash    
# Check if we are root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root! Aborting..." 1>&2
   exit 1
fi

sudo systemctl stop ccash.service

rm -r CampusCash > /dev/null 2>&1
killall Campusd > /dev/null 2>&1
rm Campusd > /dev/null 2>&1

export BDB_INCLUDE_PATH="/usr/local/BerkeleyDB.6.2/include"
export BDB_LIB_PATH="/usr/local/BerkeleyDB.6.2/lib"

cd ~
git clone https://github.com/SaltineChips/CampusCash.git
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

sleep 10

[ -f /root/Campusd ] && echo "Copy OK." || cp  ~/CampusCash/src/CampusCashd ~/Campusd

sleep 1

sudo systemctl start ccash.service

wget https://raw.githubusercontent.com/M1chlCZ/CampusCash-MN-install/main/env.sh
source env.sh

sleep 5
source ~/.profile

rm -r CampusCash

cat << "EOF"
            Update complete!

           |Brought to you by|         
  __  __ _  ____ _   _ _     ____ _____
 |  \/  / |/ ___| | | | |   / ___|__  /
 | |\/| | | |   | |_| | |  | |     / / 
 | |  | | | |___|  _  | |__| |___ / /_ 
 |_|  |_|_|\____|_| |_|_____\____/____|
       For complains Tweet @M1chl 

CCASH: Ccbbd6uUZF2GD5wE5LEfjGPA3YWPjoLC6P

EOF

read -p "You may need run mnstart command to start a masternode after update. Press ENTER to continue " -n1 -s

echo ""
EOL

cat > ~/.commands/mn2setup << EOL
#!/bin/bash    

read -p "This is utility for setting up second MN on VPS with additional IPv6, refer to your VPS provider for info how to set it up. \n Press enter to continue, or ctrl+c to terminate this procedure " -n1 -s

cp ~/.CCASH ~/.CCASH2
rm ~/.CCASH2/CampusCash.conf



RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

if [ -z "$EXTERNALIP" ]; then
    EXTERNALIP=`dig +short -6 myip.opendns.com aaaa @resolver1.ipv6-sandbox.opendns.com`
fi

if [ -z "$ARGUMENTIP" ]; then
      if [ -z "$EXTERNALIP" ]; then
            echo "Script tried unsuccessfully find your IPv6 interface, please make sure you have IPv6 activated on this VPS"
            echo "If everything is in order and you are sure of it, please enter your IPv6 manually"
            sleep 2
      fi
    read -e -p "Server IP Address: " -i $EXTERNALIP -e IP
fi

if [ -z "$KEY" ]; then
    read -e -p "Masternode Private Key for your second MN : " KEY
fi

touch ~/.CCASH2/CampusCash.conf
cat > ~/.CCASH2/CampusCash.conf << "EOF"
${INSTALLERUSED}
rpcuser=${RPCUSER}
rpcpassword=${RPCPASSWORD}
rpcallowip=127.0.0.1
rpcport=12001
listen=1
server=1
maxconnections=150
externalip=[${IP}]
bind=[${IP}]:19427
masternodeaddr=[${IP}]:19427
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
EOF

chmod 0600 ~/.CCASH2/CampusCash.conf
chown -R $USER:$USER ~/.CCASH2

cat > /etc/systemd/system/ccash2.service << "EOF"
[Unit]
Description=CCASHD2
After=network.target
[Service]
Type=forking
User=root
WorkingDirectory=/root/
ExecStart=/root/Campusd -conf=/root/.CCASH2/CampusCash.conf -datadir=/root/.CCASH2 -listen=12001
ExecStop=/root/Campusd -conf=/root/.CCASH2/CampusCash.conf -datadir=/root/.CCASH2 -listen=12001
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable ccash2.service
sudo systemctl start ccash2.service

clear

echo "" && echo "Masternode #2 setup complete" && echo ""

cat << "EOF"
           |Brought to you by|         
  __  __ _  ____ _   _ _     ____ _____
 |  \/  / |/ ___| | | | |   / ___|__  /
 | |\/| | | |   | |_| | |  | |     / / 
 | |  | | | |___|  _  | |__| |___ / /_ 
 |_|  |_|_|\____|_| |_|_____\____/____|
       For complains Tweet @M1chl 

CCASH: Ccbbd6uUZF2GD5wE5LEfjGPA3YWPjoLC6P

EOF

read -p "Press Enter to continue" -n1 -s

EOL

cat > ~/.commands/getinfo2 << EOL
#!/bin/bash    
./Campusd -conf=/root/.CCASH2/CampusCash.conf -datadir=/root/.CCASH2 getinfo
EOL

cat > ~/.commands/mn2start << EOL
#!/bin/bash    
./Campusd -conf=/root/.CCASH2/CampusCash.conf -datadir=/root/.CCASH2 masternode start
EOL

cat > ~/.commands/mn2status << EOL
#!/bin/bash    
./Campusd -conf=/root/.CCASH2/CampusCash.conf -datadir=/root/.CCASH2 masternode status
EOL

cat > ~/.commands/startd2 << EOL
#!/bin/bash
systemctl start ccash2.service > /dev/null 2>&1
echo "CampusCash Deamon #2 is running..."
EOL

cat > ~/.commands/stopd2 << EOL
#!/bin/bash
systemctl stop ccash2.service
sleep 1
echo "CampusCash Deamon #2 is innactive..."
EOL


chmod +x /root/.commands/getinfo
chmod +x /root/.commands/mnstart
chmod +x /root/.commands/mnstatus
chmod +x /root/.commands/startd
chmod +x /root/.commands/stopd
chmod +x /root/.commands/commandUpdate
chmod +x /root/.commands/campusUpdate
chmod +x /root/.commands/gethelp
chmod +x /root/.commands/getpeerinfo
chmod +x /root/.commands/clearbanned
chmod +x /root/.commands/getBootstrap
chmod +x /root/.commands/mn2setup
chmod +x /root/.commands/mn2start
chmod +x /root/.commands/mn2status
chmod +x /root/.commands/startd2
chmod +x /root/.commands/stopd2

. .commands/gethelp

rm ~/env.sh > /dev/null 2>&1