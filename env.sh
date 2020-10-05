#!/bin/bash
echo "Setting up enviromental commands..."
cd ~
mkdir .commands
echo "export PATH="$PATH:/root/.commands"" >> ~/.profile
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

chmod +x /root/.commands/getinfo
chmod +x /root/.commands/mnstart
chmod +x /root/.commands/mnstatus

. ~/.profile

clear