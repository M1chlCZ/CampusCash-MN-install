echo "Setting up enviromental commands..."
mkdir .commands
echo "export PATH="$PATH:/root/.commands"" >> ~/.profile
cat > /root/.commands/hello << EOL
#!/bin/bash    
echo My first program
EOL
chmod +x /root/.commands/hello
sudo . ~/.profile