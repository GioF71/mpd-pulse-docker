ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS base

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install pulseaudio-utils -y

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /app/assets -p

COPY app/assets/pulse-client-template.conf /app/assets/pulse-client-template.conf
COPY app/assets/mpd-template-initial.conf /app/assets/
COPY app/assets/mpd-template-pulse-output.conf /app/assets/
COPY app/assets/mpd-template-httpd-output.conf /app/assets/
COPY app/assets/mpd-template-final.conf /app/assets/

VOLUME /music
VOLUME /playlists
VOLUME /db

EXPOSE 6600
EXPOSE 8000

ENV PUID 1000
ENV PGID 1000

ENV OUTPUT_NAME mpd-pulse

ENV QOBUZ_PLUGIN_ENABLED no
ENV QOBUZ_APP_ID ID
ENV QOBUZ_APP_SECRET SECRET
ENV QOBUZ_USERNAME USERNAME
ENV QOBUZ_PASSWORD PASSWORD
ENV QOBUZ_FORMAT_ID N

ENV TIDAL_PLUGIN_ENABLED no
ENV TIDAL_APP_TOKEN TOKEN
ENV TIDAL_USERNAME USERNAME
ENV TIDAL_PASSWORD PASSWORD
ENV TIDAL_AUDIOQUALITY Q

ENV REPLAYGAIN_MODE off
ENV REPLAYGAIN_PREAMP 0
ENV REPLAYGAIN_MISSING_PREAMP 0
ENV REPLAYGAIN_LIMIT yes
ENV VOLUME_NORMALIZATION no

ENV MPD_PULSE_ENABLE_HTTPD no
ENV MPD_PULSE_HTTPD_NAME ""
ENV MPD_PULSE_HTTPD_ALWAYS_ON ""
ENV MPD_PULSE_HTTPD_TAGS ""

ENV STARTUP_DELAY_SEC 0

COPY app/bin/run-mpd.sh /app/run-mpd.sh
RUN chmod 755 /app/run-mpd.sh

ENTRYPOINT ["/app/run-mpd.sh"]
