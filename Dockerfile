from ubuntu:focal

ENV UNAME mpd

RUN apt-get update
RUN apt-get install mpd -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install pulseaudio-utils -y

RUN rm -rf /var/lib/apt/lists/*


# Set up the user
RUN export UNAME=$UNAME UID=1000 GID=1000 && \
    mkdir -p "/home/${UNAME}" && \
    echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${UID}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    chown ${UID}:${GID} -R /home/${UNAME} && \
    gpasswd -a ${UNAME} audio

RUN groups mpd

COPY assets/pulse-client.conf /etc/pulse/client.conf


#RUN mkdir -p /home/mpd/.mpd

RUN chown -R ${UID}:${GID} /home/${UNAME}
#RUN chown -R mpd:mpd /home/mpd/*

#VOLUME /home/mpd/.mpd/db
#VOLUME /home/mpd/.mpd/music
#VOLUME /home/mpd/.mpd/playlists

EXPOSE 6600

#ENV QOBUZ_PLUGIN_ENABLED no
#ENV QOBUZ_APP_ID ID
#ENV QOBUZ_APP_SECRET SECRET
#ENV QOBUZ_USERNAME USERNAME
#ENV QOBUZ_PASSWORD PASSWORD
#ENV QOBUZ_FORMAT_ID N

#ENV TIDAL_PLUGIN_ENABLED no
#ENV TIDAL_APP_TOKEN TOKEN
#ENV TIDAL_USERNAME USERNAME
#ENV TIDAL_PASSWORD PASSWORD
#ENV TIDAL_AUDIOQUALITY Q

#ENV REPLAYGAIN_MODE off
#ENV REPLAYGAIN_PREAMP 0
#ENV REPLAYGAIN_MISSING_PREAMP 0
#ENV REPLAYGAIN_LIMIT yes
#ENV VOLUME_NORMALIZATION no

ENV STARTUP_DELAY_SEC 0

COPY assets/mpd.conf /etc/mpd.conf
COPY assets/run-mpd.sh /run-mpd.sh
RUN chmod 755 /run-mpd.sh

RUN mkdir -p /home/$UNAME/db
RUN mkdir -p /home/$UNAME/music
RUN mkdir -p /home/$UNAME/playlists

RUN id mpd
RUN chown -R 1000:1000 /home/$UNAME
#RUN chown -R mpd:audio /home/$UNAME

USER $UNAME
ENV HOME /home/$UNAME

RUN ls -la /home/$UNAME

ENTRYPOINT ["/run-mpd.sh"]
