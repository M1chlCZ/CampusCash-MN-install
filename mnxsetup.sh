#!/bin/bash    
NUMBER=$1

#for ((i=0; i<$NUMBER; i++)); 
#do
#  echo "Welcome $i times"
#done

# Check for systemd
systemctl --version >/dev/null 2>&1 || { echo "Ubuntu 18.04+ is required. Are you using Ubuntu 16.04?"  >&2; exit 1; }

clear 

#echo "This is utility for setting up second MN on VPS with additional IPv6, refer to your VPS provider for info how to set it up."
#read -p "Press enter to continue, or ctrl+c to terminate this procedure " -n1 -s

#echo "Checking IPv6, please wait"

if [ -z "$EXTERNALIP" ]; then
    EXTERNALIP=`dig +short -6 myip.opendns.com aaaa @resolver1.ipv6-sandbox.opendns.com`
fi

if [ -z "$ARGUMENTIP" ]; then
      if [ -z "$EXTERNALIP" ]; then
            echo "Script tried unsuccessfully find your IPv6 interface, please make sure you have IPv6 activated on this VPS"
            echo ""
            sleep 2
            exit 1
       else
            echo "Please confirm your IP address by pressing ENTER"
            echo ""
      fi
    read -e -p "Server IPv6 Address: " -i $EXTERNALIP -e IP
fi

NETMASK=$(ifconfig | grep $EXTERNALIP | grep -oP '(?<=prefixlen )[^ ]*')
NETMASK4=$(ifconfig | grep -oP '(?<=netmask )[^ ]*' | head -n1)
IP4=$(ifconfig | grep -oP '(?<=inet )[^ ]*' | head -n1)
GATEWAY=$(/bin/ip route | grep -oP '(?<=via )[^ ]*' | head -n 1)
LASTNUM=$($EXTERNALIP | cut -d':' -f 8)
CUTIP=$(echo "$EXTERNALIP" | rev | cut -c5- | rev)
INTERFACE=$(/bin/ip link show | grep -oP '(?<=2: )[^ ]*' | cut -d':' -f 1)


if [ "$NETMASK4" == "255.255.255.255" ]; then
    BITS4="32"
elif [ "$NETMASK4" == "255.255.255.254" ]; then
    BITS4="31"
elif [ "$NETMASK4" == "255.255.255.252" ]; then
    BITS4="29"
elif [ "$NETMASK4" == "255.255.255.248" ]; then
    BITS4="28"
elif [ "$NETMASK4" == "255.255.255.224" ]; then
    BITS4="27"
elif [ "$NETMASK4" == "255.255.255.192" ]; then
    BITS4="26"
elif [ "$NETMASK4" == "255.255.255.128" ]; then
    BITS4="25"
elif [ "$NETMASK4" == "255.255.255.0" ]; then
    BITS4="24"
elif [ "$NETMASK4" == "255.255.254.0" ]; then
    BITS4="23"
elif [ "$NETMASK4" == "255.255.252.0" ]; then
    BITS4="22"
elif [ "$NETMASK4" == "255.255.248.0" ]; then
    BITS4="21"
elif [ "$NETMASK4" == "255.255.240.0" ]; then
    BITS4="20"
elif [ "$NETMASK4" == "255.255.224.0" ]; then
    BITS4="19"
elif [ "$NETMASK4" == "255.255.192.0" ]; then
    BITS4="18"
fi

NEWIP=""

for ((i=1; i<$NUMBER+1; i++)); 
do
    if [ $i -lt 10 ]; then
        PREFIX="000"
    elif [ $i -lt 100 ]; then
        PREFIX="00" 
    elif [ $i -lt 1000 ]; then
        PREFIX="0"
    fi
    NEWIP+=",$CUTIP$PREFIX$i/$NETMASK"

done


cd /etc/netplan
rm *
touch 10-ens3.yaml

cat > 10-ens3.yaml << EOL
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses: [$IP4/$BITS4,$EXTERNALIP/$NETMASK$NEWIP]
      gateway4: $GATEWAY
      nameservers:
        addresses: [8.8.8.8]
      routes:
      - to: 169.254.0.0/16
        via: $GATEWAY
        metric: 100
EOL

netplan apply

cd

clear

systemctl stop ccash.service 
sleep 2

echo "Copying blockchain for Mastenode #2"
rm ~/.CCASH/debug.log
touch ~/.CCASH/debug.log
rsync -av --progress ~/.CCASH/* ~/.CCASH2
rm ~/.CCASH2/wallet.dat
rm ~/.CCASH2/CampusCash.conf
systemctl start ccash.service 

clear

USER=root
RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)




if [ -z "$ARGUMENTIP" ]; then
      if [ -z "$EXTERNALIP" ]; then
            echo "Script tried unsuccessfully find your IPv6 interface, please make sure you have IPv6 activated on this VPS"
            echo "If everything is in order and you are sure of it, please enter your IPv6 manually"
            echo ""
            sleep 2
       else
            echo "Please confirm your IP address by pressing ENTER"
            echo ""
      fi
    read -e -p "Server IPv6 Address: " -i $EXTERNALIP -e IP
fi

if [ -z "$KEY" ]; then
    read -e -p "Masternode Private Key for your second MN : " KEY
fi
echo ""
echo "Paste this to your masternode.conf: <MN name> [${EXTERNALIP}]:19427 ${KEY} <TX ID>"
read -p "Press Enter to continue" -n1 -s

touch ~/.CCASH2/CampusCash.conf
cat > ~/.CCASH2/CampusCash.conf << EOL
${INSTALLERUSED}
rpcuser=${RPCUSER}
rpcpassword=${RPCPASSWORD}
rpcallowip=127.0.0.1
rpcport=12001
listen=1
server=1
daemon=1
maxconnections=150
externalip=[${IP}]
bind=[${IP}]:19427
masternodeaddr=[${IP}]:19427
masternodeprivkey=${KEY}
masternode=1
addnode=157.230.107.144:19427
addnode=89.40.10.129:19427
addnode=45.77.58.250:19427
addnode=104.131.27.134:19427
addnode=138.68.10.197:19427
addnode=212.24.103.156:19427
addnode=110.232.115.241:19427
addnode=139.99.239.62:19427
addnode=194.135.81.164:19427
addnode=161.35.231.193:19427
addnode=64.225.122.213:19427
addnode=82.165.119.20:19427
addnode=185.5.53.254:19427
addnode=138.197.161.183:19427
addnode=176.223.128.109:19427
addnode=66.42.71.176:19427
addnode=94.176.232.189:19427
addnode=185.81.167.251:19427
addnode=82.165.119.20:19427
addnode=104.238.156.128:19427
addnode=85.214.212.126:19427
EOL

chmod 0600 ~/.CCASH2/CampusCash.conf
chown -R $USER:$USER ~/.CCASH2

cat > /etc/systemd/system/ccash2.service << EOL
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
EOL

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