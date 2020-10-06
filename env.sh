#!/bin/bash

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
clear

# Bootstrap
if [[ ("$BOOTSTRAP" == "y" || "$BOOTSTRAP" == "Y" || "$BOOTSTRAP" == "") ]]; then
  echo "Downloading bootstrap..."
  cd ~
  git clone https://github.com/M1chlCZ/CampusCash-Bootstrap.git
  cd CampusCash-Bootstrap
  mv * /root/.CCASH
  cd ~
  sudo rm -r CampusCash-Bootstrap
fi