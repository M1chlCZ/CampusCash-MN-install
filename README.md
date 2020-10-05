# CampusCash Masternode install script

Script to install a CampusCash Masternode on Linux VPS

1) Make sure that you have your Masternode setup up locally
2) You can use any VPS with minimum of 512MB RAM with Ubuntu 18.04+ OS, other Linux distros are not guaranteed.

Paste this into terminal:

```
wget https://raw.githubusercontent.com/M1chlCZ/CampusCash-MN-install/main/ccashMNinstall.sh && sudo bash ccashMNinstall.sh && . ~/.profile
```
And follow on screen prompts.

There are 3 additional commands which is set inside the .profile file, which can be used anywhere and those are
```
getinfo
```
For getting info about Campus Cash daemon

```
mnstart
```
For starting masternode

```
mnstatus
```
For checking masternode status
