#!/bin/sh

#sed -i 's/QOBUZ_PLUGIN_ENABLED/'"$QOBUZ_PLUGIN_ENABLED"'/g' /etc/mpd.conf
#sed -i 's/QOBUZ_APP_ID/'"$QOBUZ_APP_ID"'/g' /etc/mpd.conf
#sed -i 's/QOBUZ_APP_SECRET/'"$QOBUZ_APP_SECRET"'/g' /etc/mpd.conf
#sed -i 's/QOBUZ_USERNAME/'"$QOBUZ_USERNAME"'/g' /etc/mpd.conf
#sed -i 's/QOBUZ_PASSWORD/'"$QOBUZ_PASSWORD"'/g' /etc/mpd.conf
#sed -i 's/QOBUZ_FORMAT_ID/'"$QOBUZ_FORMAT_ID"'/g' /etc/mpd.conf

#sed -i 's/TIDAL_PLUGIN_ENABLED/'"$TIDAL_PLUGIN_ENABLED"'/g' /etc/mpd.conf
#sed -i 's/TIDAL_APP_TOKEN/'"$TIDAL_APP_TOKEN"'/g' /etc/mpd.conf
#sed -i 's/TIDAL_USERNAME/'"$TIDAL_USERNAME"'/g' /etc/mpd.conf
#sed -i 's/TIDAL_PASSWORD/'"$TIDAL_PASSWORD"'/g' /etc/mpd.conf
#sed -i 's/TIDAL_AUDIOQUALITY/'"$TIDAL_AUDIOQUALITY"'/g' /etc/mpd.conf

#sed -i 's/REPLAYGAIN_MODE/'"$REPLAYGAIN_MODE"'/g' /etc/mpd.conf
#sed -i 's/REPLAYGAIN_PREAMP/'"$REPLAYGAIN_PREAMP"'/g' /etc/mpd.conf
#sed -i 's/REPLAYGAIN_MISSING_PREAMP/'"$REPLAYGAIN_MISSING_PREAMP"'/g' /etc/mpd.conf
#sed -i 's/REPLAYGAIN_LIMIT/'"$REPLAYGAIN_LIMIT"'/g' /etc/mpd.conf
#sed -i 's/VOLUME_NORMALIZATION/'"$VOLUME_NORMALIZATION"'/g' /etc/mpd.conf

cat /etc/mpd.conf

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."
#/usr/bin/mpd --stderr --no-daemon --verbose /etc/mpd.conf
/usr/bin/mpd --stderr --no-daemon /etc/mpd.conf
