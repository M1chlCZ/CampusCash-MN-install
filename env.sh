echo "Setting up enviromental commands..."
cd ~

rm /root/.commands/getinfo
rm /root/.commands/mnstart
rm /root/.commands/mnstatus
rm /root/.commands/startd
rm /root/.commands/campusUpdate

cat > ~/.commands/gethelp << EOL
#!/bin/bash
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
echo "campusUpdate         | Update CampusCash deamon"
echo ""
echo "gethelp              | Show help"
echo "---------------------------------------------------"
echo ""

EOL

cat > ~/.commands/getinfo << EOL
#!/bin/bash    
~/Campusd getinfo
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
~/Campusd
EOL

cat > ~/.commands/campusUpdate << EOL
#!/bin/bash    
# Check if we are root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root! Aborting..." 1>&2
   exit 1
fi

sudo systemctl stop ccash.service

rm -r CampusCash
killall Campusd
rm Campusd

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
sleep 5

sudo systemctl start ccash.service

sleep 5

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

read -p "You may need run mnstart to start a masternode after update. Press ENTER to continue " -n1 -s

EOL

chmod +x /root/.commands/getinfo
chmod +x /root/.commands/mnstart
chmod +x /root/.commands/mnstatus
chmod +x /root/.commands/startd
chmod +x /root/.commands/campusUpdate
chmod +x /root/.commands/gethelp

rm ~/env.sh