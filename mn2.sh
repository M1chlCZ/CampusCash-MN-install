#!/bin/bash    

clear 

read -p "This is utility for setting up second MN on VPS with additional IPv6, refer to your VPS provider for info how to set it up. Press enter to continue, or ctrl+c to terminate this procedure " -n1 -s

clear

echo "Copying blockchain for Mastenode #2"
rsync -ah --progress ~/.CCASH ~/.CCASH2
rm ~/.CCASH2/CampusCash.conf
rm ~/.CCASH2/wallet.dat

clear

RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

if [ -z "$EXTERNALIP" ]; then
    echo "getting IPv6..."
    EXTERNALIP=`dig +short -6 myip.opendns.com aaaa @resolver1.ipv6-sandbox.opendns.com`
fi

if [ -z "$ARGUMENTIP" ]; then
      if [ -z "$EXTERNALIP" ]; then
            echo "Script tried unsuccessfully find your IPv6 interface, please make sure you have IPv6 activated on this VPS"
            echo "If everything is in order and you are sure of it, please enter your IPv6 manually"
            sleep 2
      fi
    read -e -p "Server IPv6 Address: " -i $EXTERNALIP -e IP
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

rm ~/mn2.sh
read -p "Press Enter to continue" -n1 -s