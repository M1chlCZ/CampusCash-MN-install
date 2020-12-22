# CampusCash Masternode install script

Script to install a CampusCash Masternode on Linux VPS

1) Make sure that you have your Masternode setup up locally
2) You can use any VPS with minimum of 512MB RAM with Ubuntu 18.04+ OS, other Linux distros are not guaranteed.

Paste this into terminal:

```
wget https://raw.githubusercontent.com/M1chlCZ/CampusCash-MN-install/main/ccashMNinstall.sh && sudo bash ccashMNinstall.sh && . ~/.profile
```
And follow on screen prompts.

This script contains additional commands, which can be used anywhere. Here is list of them.
```
Command              | What does it do?
---------------------------------------------------
getinfo              | Get wallet info

mnstart              | Start masternode

mnstatus             | Status of the masternode

startd               | Start CampusCash deamon

stopd                | Stop CampusCash deamon

campusUpdate         | Update CampusCash deamon

commandUpdate        | Update List of commands

getpeerinfo          | Show peer info

clearbanned          | Clear all banned IPs

mn2setup             | Set up MN #2

mn2start             | Start MN #2

mn2status            | Status of MN #2

startd2              | Start CampusCash deamon for MN #2

stopd2               | Stop CampusCash deamon for MN #2

getBootstrap2        | Get a bootstrap for MN #2

gethelp              | Show help
---------------------------------------------------
```

Any help with this script can be provided through:


Discord: https://discord.gg/7uCjtHR

Twitter: https://ctt.ac/38x8c 

