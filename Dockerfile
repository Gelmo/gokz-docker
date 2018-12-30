FROM joshhsoj1902/linuxgsm-docker:latest

WORKDIR /home/linuxgsm/linuxgsm

# Stop apt-get asking to get Dialog frontend
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LGSM_GAMESERVERNAME csgoserver
ENV LGSM_UPDATEINSTALLSKIP UPDATE
EXPOSE 27015/tcp
EXPOSE 27015/udp

USER root 
 

# Install dependencies and clean
RUN apt-get update && \
    apt-get install -y \
        sqlite \
        rsync \
        zlib1g:i386 \
        libc6-i386 \
        lib32stdc++6 \
    # Cleanup
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

COPY --from=joshhsoj1902/parse-env:1.0.3 /go/src/github.com/joshhsoj1902/parse-env/main /usr/bin/parse-env
COPY --from=hairyhenderson/gomplate:v3.1.0-alpine /bin/gomplate /usr/bin/gomplate

# Switch to the user linuxgsm
USER linuxgsm

RUN cd \
 && mkdir downloads \
 && cd downloads/ \
 && wget https://bitbucket.org/kztimerglobalteam/gokz/downloads/GOKZ-latest.zip \
 && unzip GOKZ* && rm -rf GOKZ* \
 && rsync -Pva /home/linuxgsm/downloads/ /home/linuxgsm/linuxgsm/serverfiles/csgo/ \
 && rm -rf ~/downloads/*

RUN cd ~/downloads/ \
 && curl -s https://api.github.com/repos/danzayau/MovementAPI/releases/latest | grep browser_download_url | cut -d '"' -f 4 | xargs wget \
 && unzip -o Movement* \
 && rsync -Pva /home/linuxgsm/downloads/addons/ /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/ \
 && rm -rf ~/downloads/*

RUN cd ~/downloads/ \
 && wget https://users.alliedmods.net/~drifter/builds/dhooks/2.2/dhooks-2.2.0-hg126-linux.tar.gz \
 && tar -xzvf dhooks* \
 && rsync -Pva /home/linuxgsm/downloads/addons/ /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/ \
 && rm -rf ~/downloads/*

RUN cd ~/downloads/ \
 && wget https://bitbucket.org/kztimerglobalteam/globalrecordssmplugin/downloads/GlobalAPI-Core-v.1.2.0.zip \
 && unzip Global* \
 && rm -rf ./*.zip \
 && rsync -Pva /home/linuxgsm/downloads/GlobalAPI-Core-v.1.2.0/ /home/linuxgsm/linuxgsm/serverfiles/csgo/ \
 && rm -rf ~/downloads/*

RUN cd /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/extensions/ \
 && wget https://github.com/Accelerator74/Cleaner/raw/master/Release/cleaner.ext.2.csgo.so \
 && wget https://github.com/Accelerator74/Cleaner/raw/master/Release/cleaner.autoload \
 && wget https://github.com/thraaawn/SMJansson/raw/master/bin/smjansson.ext.so

RUN cd ~/downloads/ \
 && wget https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git126-linux.tar.gz \
 && tar -xzvf Steam* \
 && rsync -Pva /home/linuxgsm/downloads/addons/ /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/ \
 && rm -rf ~/downloads/*

RUN cd /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/plugins/ \
 && wget https://bitbucket.org/GoD_Tony/updater/downloads/updater.smx \
 && chmod 600 ./*.smx

RUN cd /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/gamedata/ \
 && wget https://raw.githubusercontent.com/nikooo777/ckSurf/master/csgo/addons/sourcemod/gamedata/cleaner.txt

RUN cd /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/extensions/ \
 && chmod 700 ./*.so \
 && chmod 700 ./*.autoload

USER root 

RUN find /home/linuxgsm/linuxgsm -type f -name "*.sh" -exec chmod u+x {} \; \
 && find /home/linuxgsm/linuxgsm -type f -name "*.py" -exec chmod u+x {} \; \
 && chmod u+x /home/linuxgsm/linuxgsm/lgsm/functions/README.md

ADD --chown=linuxgsm:linuxgsm common.cfg.tmpl ./lgsm/config-default/config-lgsm/
ADD --chown=linuxgsm:linuxgsm gokz-runner.sh docker-liveness.sh docker-readiness.sh ./
ADD --chown=linuxgsm:linuxgsm functions/* /home/linuxgsm/linuxgsm/lgsm/functions/
ADD --chown=linuxgsm:linuxgsm custom_configs/ /home/linuxgsm/linuxgsm-configs
ADD --chown=linuxgsm:linuxgsm databases.cfg /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/configs/

USER linuxgsm

HEALTHCHECK --start-period=60s --timeout=300s --interval=60s --retries=3 CMD ./docker-liveness.sh

RUN ./gokz-runner.sh

CMD ["bash"]