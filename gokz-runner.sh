#!/bin/bash

#Set ENV defaults

if [ -n "$LGSM_PORT" ]; then
  if [ -z "$LGSM_CLIENTPORT" ]; then
    clientport=$(($LGSM_PORT-10))
    echo "clientPort $clientport"
    export LGSM_CLIENTPORT=$clientport
  fi
  if [ -z "$LGSM_SOURCETVPORT" ]; then
    sourcetvport=$(($LGSM_PORT+5))
    echo "sourcetvport $sourcetvport"
    export LGSM_SOURCETVPORT=$sourcetvport
  fi
fi

parse-env --env "LGSM_" >> env.json

rm -f INSTALLING.LOCK

if [ -z "$LGSM_GAMESERVERNAME" ]; then
  echo "Need to set LGSM_GAMESERVERNAME environment"
  exit 1
fi

echo "IP is set to "${LGSM_IP}

mkdir -p ~/linuxgsm/lgsm/config-lgsm/$LGSM_GAMESERVERNAME
gomplate -d env=~/linuxgsm/env.json -f ~/linuxgsm/lgsm/config-default/config-lgsm/common.cfg.tmpl -o ~/linuxgsm/lgsm/config-lgsm/$LGSM_GAMESERVERNAME/common.cfg
if [ -f ~/linuxgsm/lgsm/config-lgsm/$LGSM_GAMESERVERNAME/$LGSM_GAMESERVERNAME.cfg.tmpl ]; then
  gomplate -d env=~/linuxgsm/env.json -f ~/linuxgsm/lgsm/config-lgsm/$LGSM_GAMESERVERNAME/$LGSM_GAMESERVERNAME.cfg.tmpl -o ~/linuxgsm/lgsm/config-lgsm/$LGSM_GAMESERVERNAME/$LGSM_GAMESERVERNAME.cfg
fi
echo "DONE GOMPLATING"

if [ -n "$LGSM_UPDATEINSTALLSKIP" ]; then
  case "$LGSM_UPDATEINSTALLSKIP" in
  "UPDATE")
      touch INSTALLING.LOCK
      ./linuxgsm.sh $LGSM_GAMESERVERNAME
      mv $LGSM_GAMESERVERNAME lgsm-gameserver
      ./lgsm-gameserver auto-install
      rm -f INSTALLING.LOCK
      
      echo "Game has been updated."
      ;;
  "INSTALL")
      touch INSTALLING.LOCK  
      ./linuxgsm.sh $LGSM_GAMESERVERNAME
      mv $LGSM_GAMESERVERNAME lgsm-gameserver
      ls -ltr
      ./lgsm-gameserver auto-install
      rm -f INSTALLING.LOCK
       
      echo "Game has been installed. Exiting"
      exit
      ;;
  esac
fi

if [ ! -f lgsm-gameserver ]; then
    echo "No game is installed, please set LGSM_UPDATEINSTALLSKIP"
    exit 1
fi

wget https://kzmaps.tangoworldwide.net/mapcycles/gokz.txt

mv /home/linuxgsm/linuxgsm/gokz.txt /home/linuxgsm/linuxgsm/serverfiles/csgo/mapcycle.txt

touch /home/linuxgsm/linuxgsm/log/script/lgsm-gameserver-script.log

chmod +x /home/linuxgsm/linuxgsm/lgsm/functions/*.sh

echo "metamod" | ./lgsm-gameserver mi
sleep 5s

echo "sourcemod" | ./lgsm-gameserver mi
sleep 5s