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
rm /root/.commands/getBootstrap2 > /dev/null 2>&1
rm /root/.commands/mn2setup > /dev/null 2>&1
rm /root/.commands/mn2start > /dev/null 2>&1
rm /root/.commands/mn2status > /dev/null 2>&1
rm /root/.commands/startd2 > /dev/null 2>&1
rm/root/.commands/stopd2 > /dev/null 2>&1

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
echo "getinfo2             | Get 2nd deamon info"
echo ""
echo "mn2setup             | Set up MN #2"
echo ""
echo "mn2start             | Start MN #2"
echo ""
echo "mn2status            | Status of MN #2"
echo ""
echo "startd2              | Start CampusCash deamon for MN #2"
echo ""
echo "stopd2               | Stop CampusCash deamon for MN #2"
echo ""
echo "getBootstrap2        | Get a bootstrap for MN #2"
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

cd ~

mv /root/.CCASH/CampusCash.conf CampusCash.conf
mv /root/.CCASH/wallet.dat wallet.dat

apt-get install -y unzip
cd ~/.CCASH
rm -rf *
wget https://github.com/SaltineChips/CampusCash/releases/download/1.0.0.0/CCASH_SnapShot.zip;
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

cat > ~/.commands/getBootstrap2 << EOL
systemctl stop ccash2.service 

cd ~

mv /root/.CCASH2/CampusCash.conf CampusCash.conf
mv /root/.CCASH2/wallet.dat wallet.dat

apt-get install -y unzip
cd ~/.CCASH2
rm -rf *
wget https://github.com/SaltineChips/CampusCash/releases/download/1.0.0.0/CCASH_SnapShot.zip;
unzip CCASH_bootstrap.zip
rm CCASH_bootstrap.zip
cd ~

mv CampusCash.conf /root/.CCASH2/CampusCash.conf
mv wallet.dat /root/.CCASH2/wallet.dat

systemctl start ccash2.service > /dev/null 2>&1
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
sudo systemctl stop ccash2.service > /dev/null 2>&1

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
sudo systemctl start ccash2.service > /dev/null 2>&1

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
wget https://raw.githubusercontent.com/M1chlCZ/CampusCash-MN-install/main/mn2.sh > /dev/null 2>&1
source mn2.sh
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
chmod +x /root/.commands/getBootstrap2
chmod +x /root/.commands/getinfo2
chmod +x /root/.commands/mn2setup
chmod +x /root/.commands/mn2start
chmod +x /root/.commands/mn2status
chmod +x /root/.commands/startd2
chmod +x /root/.commands/stopd2

. .commands/gethelp

rm ~/env.sh > /dev/null 2>&1