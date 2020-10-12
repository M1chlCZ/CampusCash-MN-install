echo "Setting up enviromental commands..."
cd ~

rm /root/.commands/getinfo > /dev/null 2>&1
rm /root/.commands/mnstart > /dev/null 2>&1
rm /root/.commands/mnstatus > /dev/null 2>&1
rm /root/.commands/startd > /dev/null 2>&1
rm /root/.commands/stopd > /dev/null 2>&1
rm /root/.commands/commandUpdate > /dev/null 2>&1
rm /root/.commands/campusUpdate > /dev/null 2>&1
rm /root/.commands/clearbanned > /dev/null 2>&1

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

cat > ~/.commands/commandUpdate << EOL
#!/bin/bash    
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
cp  ~/CampusCash/src/CampusCashd /root/Campusd
cp  CampusCash/src/CampusCashd /root/Campusd #possible retarded fix

sleep 10

[ -f /root/Campusd ] && echo "Copy OK." || cp  ~/CampusCash/src/CampusCashd ~/Campusd

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

. .commands/gethelp

rm ~/env.sh > /dev/null 2>&1