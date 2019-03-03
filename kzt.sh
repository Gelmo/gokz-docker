#!/bin/bash

cd ~/linuxgsm/

./lgsm-gameserver auto-install

cd \
 && mkdir downloads \
 && cd downloads/ \
 && wget https://bitbucket.org/kztimerglobalteam/kztimerglobal/downloads/1.90_Full.zip \
 && unzip 1.90_Full.zip && rm -rf 1.90_Full.zip \
 && rsync -Pva /home/linuxgsm/downloads/ /home/linuxgsm/linuxgsm/serverfiles/csgo/ \
 && rm -rf ~/downloads/*

cd \
 && wget https://kzmaps.tangoworldwide.net/mapcycles/kztimer.txt \
 && mv /home/linuxgsm/linuxgsm/kztimer.txt /home/linuxgsm/linuxgsm/serverfiles/csgo/mapcycle.txt

cd ~/linuxgsm/

echo "metamod" | ./lgsm-gameserver mi
sleep 5s

echo "sourcemod" | ./lgsm-gameserver mi
sleep 5s

mv -f databases.cfg /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/configs/

wget https://kzmaps.tangoworldwide.net/bsps/kz_coronado_fix.bsp \
 && mv /home/linuxgsm/linuxgsm/kz_coronado_fix.bsp /home/linuxgsm/linuxgsm/serverfiles/csgo/maps/

echo "Do you want to start the server or edit configs?"
echo "[1] Start the server"
echo "[2] Do not start the server"
select yn in "1" "2"; do
    case $yn in
        1 ) ./lgsm-gameserver start; break;;
        2 ) break;;
    esac
done
