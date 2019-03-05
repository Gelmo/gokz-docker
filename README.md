# gokz-docker

## Start your container:
```
docker run -p 27015:27015/tcp -p 27015:27015/udp -ti gelmo/gokz-docker:latest
```

### You'll be at a bash shell. Add your GSLT in the appropriate field:

```
nano /home/linuxgsm/linuxgsm/lgsm/config-lgsm/csgoserver/lgsm-gameserver.cfg
```

### Add admins:

```
nano /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/configs/admins_simple.ini
```

### Start the server:

```
./lgsm-gameserver start
```

## WAIT TWO MINUTES

### Adjust other configs. Suggestions:

```
nano /home/linuxgsm/linuxgsm/serverfiles/csgo/cfg/sourcemod/mapchooser_extended.cfg
nano /home/linuxgsm/linuxgsm/serverfiles/csgo/cfg/sourcemod/rtv.cfg
```

### Change map via !map command or use RCON:

```
./lgsm-gameserver console
map kz_lume
```

## Advanced:

Documentation for LinuxGSM can be found at https://docs.linuxgsm.com/configuration/

The text editors vim and nano have been included in the image.

More documentaiton will be coming soon and I will add examples for different use-cases such as map testing.