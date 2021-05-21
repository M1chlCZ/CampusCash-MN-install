echo "Setting up enviromental commands..."
cd ~

rm  ~/.commands/gethelp > /dev/null 2>&1
rm  ~/.commands/getinfo > /dev/null 2>&1
rm  ~/.commands/mnstart > /dev/null 2>&1
rm  ~/.commands/mnstatus > /dev/null 2>&1
rm  ~/.commands/startd > /dev/null 2>&1
rm  ~/.commands/stopd > /dev/null 2>&1
rm  ~/.commands/commandUpdate > /dev/null 2>&1
rm  ~/.commands/campusUpdate > /dev/null 2>&1
rm  ~/.commands/clearbanned > /dev/null 2>&1
rm  ~/.commands/getBootstrap > /dev/null 2>&1
rm  ~/.commands/getBootstrap2 > /dev/null 2>&1
rm  ~/.commands/mn2setup > /dev/null 2>&1
rm  ~/.commands/mnxsetup > /dev/null 2>&1
rm  ~/.commands/mn2start > /dev/null 2>&1
rm  ~/.commands/mn2status > /dev/null 2>&1
rm  ~/.commands/startd2 > /dev/null 2>&1
rm  ~/.commands/stopd2 > /dev/null 2>&1
rm  ~/.commands/campusBetaInstall > /dev/null 2>&1
rm  ~/.commands/getBootstrapx > /dev/null 2>&1
rm  ~/.commands/getxinfo > /dev/null 2>&1

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

mv  ~/.CCASH/CampusCash.conf CampusCash.conf
mv  ~/.CCASH/wallet.dat wallet.dat

apt-get install -y unzip
cd ~/.CCASH
rm -rf *
wget https://github.com/CampusCash/CampusCash_Release/releases/download/1.0.14.1/CCASH_bootstrap.zip
unzip CCASH_bootstrap.zip
rm CCASH_bootstrap.zip
cd ~

mv CampusCash.conf  ~/.CCASH/CampusCash.conf
mv wallet.dat  ~/.CCASH/wallet.dat

systemctl start ccash.service > /dev/null 2>&1
echo "CampusCash Deamon is running..."
EOL

cat > ~/.commands/getBootstrapx << EOL
systemctl stop ccash\$1.service 

cd ~

mv  ~/.CCASH\$1/CampusCash.conf CampusCash.conf
mv  ~/.CCASH\$1/wallet.dat wallet.dat

apt-get install -y unzip
cd ~/.CCASH\$1
rm -rf *
wget https://github.com/CampusCash/CampusCash_Release/releases/download/1.0.14.1/CCASH_bootstrap.zip
unzip CCASH_bootstrap.zip
rm CCASH_bootstrap.zip
cd ~

mv CampusCash.conf  ~/.CCASH\$1/CampusCash.conf
mv wallet.dat  ~/.CCASH\$1/wallet.dat

systemctl start ccash\$1.service > /dev/null 2>&1
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

mv  ~/.CCASH2/CampusCash.conf CampusCash.conf
mv  ~/.CCASH2/wallet.dat wallet.dat

apt-get install -y unzip
cd ~/.CCASH2
rm -rf *
wget https://github.com/CampusCash/CampusCash_Release/releases/download/1.0.14.1/CCASH_bootstrap.zip
unzip CCASH_bootstrap.zip
rm CCASH_bootstrap.zip
cd ~

mv CampusCash.conf  ~/.CCASH2/CampusCash.conf
mv wallet.dat  ~/.CCASH2/wallet.dat

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
git clone https://github.com/CampusCash/CampusCash_Release.git
cd ~/CampusCash_Release/src
chmod a+x obj
chmod a+x leveldb/build_detect_platform
chmod a+x secp256k1
chmod a+x leveldb
chmod a+x ~/CampusCash_Release/src
chmod a+x ~/CampusCash_Release
make -f makefile.unix USE_UPNP=-
cd ~ 
cp  CampusCash_Release/src/CampusCashd  ~/Campusd

sleep 10

[ -f  ~/Campusd ] && echo "Copy OK." || cp  ~/CampusCash_Release/src/CampusCashd ~/Campusd

sleep 1

sudo systemctl start ccash.service
sudo systemctl start ccash2.service > /dev/null 2>&1

wget https://raw.githubusercontent.com/M1chlCZ/CampusCash-MN-install/main/env.sh
source env.sh

sleep 5
source ~/.profile

rm -r CampusCash_Release

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

cat > ~/.commands/campusBetaInstall << EOL
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
git clone https://github.com/SaltineChips/CampusCash.git CampusCash
cd ~/CampusCash/src
chmod a+x obj
chmod a+x leveldb/build_detect_platform
chmod a+x secp256k1
chmod a+x leveldb
chmod a+x ~/CampusCash/src
chmod a+x ~/CampusCash
make -f makefile.unix USE_UPNP=-
cd ~ 
cp  CampusCash/src/CampusCashd ~/Campusd

sleep 10

[ -f ~/Campusd ] && echo "Copy OK." || cp  ~/CampusCash/src/CampusCashd ~/Campusd

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

read -p "Beta version of CampusCash is installed" -n1 -s

echo ""
EOL

cat > ~/.commands/mn2setup << EOL
wget https://raw.githubusercontent.com/M1chlCZ/CampusCash-MN-install/main/mn2.sh > /dev/null 2>&1
source mn2.sh
EOL

cat > ~/.commands/getinfo2 << EOL
#!/bin/bash    
./Campusd -conf= ~/.CCASH2/CampusCash.conf -datadir= ~/.CCASH2 getinfo
EOL

cat > ~/.commands/mn2start << EOL
#!/bin/bash    
./Campusd -conf= ~/.CCASH2/CampusCash.conf -datadir= ~/.CCASH2 -port=12001 masternode start
EOL

cat > ~/.commands/mnxstart << EOL
#!/bin/bash    
PORT=\$((\$1 - 1))
./Campusd -conf= ~/.CCASH\$1/CampusCash.conf -datadir= ~/.CCASH\$1 -port=1200\$PORT masternode start
EOL

cat > ~/.commands/getxinfo << EOL
#!/bin/bash    
PORT=\$((\$1 - 1))
./Campusd -conf= ~/.CCASH\$1/CampusCash.conf -datadir= ~/.CCASH\$1 -port=1200\$PORT getinfo
EOL

cat > ~/.commands/mn2status << EOL
#!/bin/bash    
./Campusd -conf= ~/.CCASH2/CampusCash.conf -datadir= ~/.CCASH2 masternode status
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


chmod +x  ~/.commands/getinfo
chmod +x  ~/.commands/mnstart
chmod +x  ~/.commands/mnstatus
chmod +x  ~/.commands/startd
chmod +x  ~/.commands/stopd
chmod +x  ~/.commands/commandUpdate
chmod +x  ~/.commands/campusUpdate
chmod +x  ~/.commands/gethelp
chmod +x  ~/.commands/getpeerinfo
chmod +x  ~/.commands/clearbanned
chmod +x  ~/.commands/getBootstrap
chmod +x  ~/.commands/getBootstrap2
chmod +x  ~/.commands/getinfo2
chmod +x  ~/.commands/mn2setup
chmod +x  ~/.commands/mnxstart
chmod +x  ~/.commands/mn2start
chmod +x  ~/.commands/mn2status
chmod +x  ~/.commands/startd2
chmod +x  ~/.commands/stopd2
chmod +x  ~/.commands/campusBetaInstall
chmod +x  ~/.commands/getBootstrapx
chmod +x  ~/.commands/getxinfo

. .commands/gethelp

rm ~/env.sh > /dev/null 2>&1