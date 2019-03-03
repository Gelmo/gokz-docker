# kz-docker

## Start your container:
```
docker run -p 27015:27015/tcp -p 27015:27015/udp -ti gelmo/kz-docker:latest
```

### You'll be at a bash shell. To start the server, do the following:

#### GOKZ:
```
./gokz.sh
```

#### KZTimer:
```
./kzt.sh
```

## Advanced:

#### Changing the server config:
The server config can be found at /home/linuxgsm/linuxgsm/lgsm/config-lgsm/csgoserver/lgsm-gameserver.cfg
Documentation for this file can be found at https://docs.linuxgsm.com/configuration/linuxgsm-config

The text editors vim and nano have been included in the image; you can use these to edit the above file and any other configs you would like to adjust. Any config for a plugin or sourcemod will need to be edited after you run ./gokz.sh or ./kzt.sh. This would be a good time to setup admin configs if you don't want to use rcon. To restart the server after your adjustments have been made:
```
./lgsm-gameserver restart
```

To open rcon:
```
./lgsm-gameserver console
```

More documentaiton will be coming soon and I will add examples for different use-cases such as map testing.