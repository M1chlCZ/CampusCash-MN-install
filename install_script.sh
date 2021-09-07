#!/bin/bash
if [ -z "$JUSTDAEMON" ]; then
    read -e -p "Do you want to compile just daemon? [N/y] : " JUSTDAEMON
fi

YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)
PACMAN_CMD=$(which pacman)

if [[ ! -z $YUM_CMD ]]; then
    yum check-update
elif [[ ! -z $APT_GET_CMD ]]; then
    apt-get update
elif [[ ! -z $PACMAN_CMD ]]; then
    yes | LC_ALL=en_US.UTF-8 pacman -S $pkg
else
    echo "Cannot update repository"
    exit 1;
fi

pkgs='build-essential libssl-dev libdb-dev libdb++-dev libboost-all-dev libqrencode-dev libcurl4-openssl-dev curl libzip-dev ntp git make automake build-essential libboost-all-dev yasm binutils libcurl4-openssl-dev openssl libssl-dev libgmp-dev libtool qt5-default qttools5-dev-tools'
install=false
for pkg in $pkgs; do
  status="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg" 2>&1)"
  if [ ! $? = 0 ] || [ ! "$status" = installed ]; then
    install=true
  fi
  if "$install"; then
    if [[ ! -z $YUM_CMD ]]; then
        yum -y install $pkg
    elif [[ ! -z $APT_GET_CMD ]]; then
        apt-get install -y $pkg
    elif [[ ! -z $PACMAN_CMD ]]; then
        yes | LC_ALL=en_US.UTF-8 pacman -S $pkg
    else
        echo "error can't install package $pkg"
        exit 1;
    fi    
    install=false
  fi
done

FOLDER=$HOME/.opt/BDB62
if [ -d "$FOLDER" ]
then
    echo "DBD 6.2 already installed"
    export BDB_INCLUDE_PATH="$FOLDER/include"
    export BDB_LIB_PATH="$FOLDER/lib" 
else
    # Install Berkley DB 6.2
    echo "Installing Berkley DB..."
    cd $HOME
    wget http://download.oracle.com/berkeley-db/db-6.2.32.NC.tar.gz
    tar zxf db-6.2.32.NC.tar.gz
    cd db-6.2.32.NC/build_unix
    ../dist/configure --enable-cxx --disable-shared --prefix=$FOLDER
    make -j`nproc`
    make install
    export BDB_INCLUDE_PATH="$FOLDER/include"
    export BDB_LIB_PATH="$FOLDER/lib"
    cd $HOME
    rm db-6.2.32.NC.tar.gz
    rm -rf --interactive=never db-6.2.32.NC
fi

cd $HOME
git clone https://github.com/CampusCash/CampusCash_Core.git CampusCash

if [[ ("$JUSTDAEMON" == "y" || "$JUSTDAEMON" == "Y") ]]; then
    # Install CCASH daemon
    cd $HOME/CampusCash/src
    chmod a+x obj
    chmod a+x leveldb/build_detect_platform
    chmod a+x secp256k1
    chmod a+x leveldb
    chmod a+x $HOME/CampusCash/src
    chmod a+x $HOME/CampusCash
    make -f makefile.unix USE_UPNP=- -j`nproc`
    sleep 1
    cp CampusCashd $HOME/Campusd
    cd $HOME
    strip Campusd
    sleep 1
else
    # Install CCASH QT Wallet
    cd $HOME/CampusCash
    chmod a+x objz
    chmod a+x leveldb/build_detect_platform
    chmod a+x secp256k1
    chmod a+x leveldb
    chmod a+x $HOME/CampusCash/src
    chmod a+x $HOME/CampusCash
    qmake -qt=qt5
    make -j`nproc`
    sleep 1
    cp CampusCash-qt $HOME/CampusCash-qt
    cd $HOME
    strip Campusd
    where Campusd
    sleep 1
fi

clear