FROM giof71/mpd-base-image:ubuntu-focal

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install pulseaudio-utils -y

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /app/assets -p

COPY assets/pulse-client-template.conf /app/assets/pulse-client-template.conf
COPY assets/mpd-template.conf /app/assets/mpd-template.conf

VOLUME /music
VOLUME /playlists
VOLUME /db

EXPOSE 6600

ENV PUID 1000
ENV PGID 1000

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

COPY assets/run-mpd.sh /run-mpd.sh
RUN chmod 755 /run-mpd.sh

ENTRYPOINT ["/run-mpd.sh"]
