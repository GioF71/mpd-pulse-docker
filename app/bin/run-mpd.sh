#!/bin/bash

USER_NAME=mpd-pulse
GROUP_NAME=mpd-pulse

HOME_DIR=/home/$USER_NAME

id mpd

### create home directory and ancillary directories
if [ ! -d "$HOME_DIR" ]; then
  echo "Home directory [$HOME_DIR] not found, creating."
  mkdir -p $HOME_DIR
  chown -R $PUID:$PGID $HOME_DIR
  ls -la $HOME_DIR -d
  ls -la $HOME_DIR
fi

echo "Creating music directory"
mkdir -p "/music"
chown -R $PUID:$PGID $HOME_DIR

echo "Creating playlists directory"
mkdir -p "/playlists"
chown -R $PUID:$PGID "/playlists"

echo "Creating db directory"
mkdir -p "/db"
chown -R $PUID:$PGID "db"

### create group
if [ ! $(getent group $GROUP_NAME) ]; then
  echo "group $GROUP_NAME does not exist, creating..."
  groupadd -g $PGID $GROUP_NAME
else
  echo "group $GROUP_NAME already exists."
fi

### create user
if [ ! $(getent passwd $USER_NAME) ]; then
  echo "user $USER_NAME does not exist, creating..."
  useradd -g $PGID -u $PUID -s /bin/bash -M -d $HOME_DIR $USER_NAME
  usermod -a -G audio $USER_NAME
  id $USER_NAME
  echo "user $USER_NAME created."
else
  echo "user $USER_NAME already exists."
fi

PULSE_CLIENT_CONF="/etc/pulse/client.conf"

echo "Creating pulseaudio configuration file $PULSE_CLIENT_CONF..."
cp /app/assets/pulse-client-template.conf $PULSE_CLIENT_CONF
sed -i 's/PUID/'"$PUID"'/g' $PULSE_CLIENT_CONF
cat $PULSE_CLIENT_CONF

cp /app/assets/mpd-template-initial.conf /etc/mpd.conf

sed -i 's/USER_NAME/'"$USER_NAME"'/g' /etc/mpd.conf

sed -i 's/QOBUZ_PLUGIN_ENABLED/'"$QOBUZ_PLUGIN_ENABLED"'/g' /etc/mpd.conf
sed -i 's/QOBUZ_APP_ID/'"$QOBUZ_APP_ID"'/g' /etc/mpd.conf
sed -i 's/QOBUZ_APP_SECRET/'"$QOBUZ_APP_SECRET"'/g' /etc/mpd.conf
sed -i 's/QOBUZ_USERNAME/'"$QOBUZ_USERNAME"'/g' /etc/mpd.conf
sed -i 's/QOBUZ_PASSWORD/'"$QOBUZ_PASSWORD"'/g' /etc/mpd.conf
sed -i 's/QOBUZ_FORMAT_ID/'"$QOBUZ_FORMAT_ID"'/g' /etc/mpd.conf

sed -i 's/TIDAL_PLUGIN_ENABLED/'"$TIDAL_PLUGIN_ENABLED"'/g' /etc/mpd.conf
sed -i 's/TIDAL_APP_TOKEN/'"$TIDAL_APP_TOKEN"'/g' /etc/mpd.conf
sed -i 's/TIDAL_USERNAME/'"$TIDAL_USERNAME"'/g' /etc/mpd.conf
sed -i 's/TIDAL_PASSWORD/'"$TIDAL_PASSWORD"'/g' /etc/mpd.conf
sed -i 's/TIDAL_AUDIOQUALITY/'"$TIDAL_AUDIOQUALITY"'/g' /etc/mpd.conf

cat  /app/assets/mpd-template-pulse-output.conf >> /etc/mpd.conf

sed -i 's/OUTPUT_NAME/'"$OUTPUT_NAME"'/g' /etc/mpd.conf

if [ -z "${MPD_PULSE_ENABLE_HTTPD}" ]; then
  echo "Variable MPD_PULSE_ENABLE_HTTPD not specified";
else
  echo "Variable MPD_PULSE_ENABLE_HTTPD specified: $MPD_PULSE_ENABLE_HTTPD";
  enable_httpd=${MPD_PULSE_ENABLE_HTTPD^^}
  echo "enable_httpd: $enable_httpd";
  if [[ "$enable_httpd" == "Y" || "$enable_httpd" == "YES" ]]; then
    echo "Variable MPD_PULSE_ENABLE_HTTPD set to enabled.";
    cat  /app/assets/mpd-template-httpd-output.conf >> /etc/mpd.conf
    httpd_name=$MPD_PULSE_HTTPD_NAME
    if [ -z "${httpd_name}" ]; then
      httpd_name="httpd"
    fi
    httpd_always_on=$MPD_PULSE_HTTPD_ALWAYS_ON
    if [ -z "${httpd_always_on}" ]; then
      httpd_always_on="yes"
    fi
    httpd_tags=$MPD_PULSE_HTTPD_TAGS
    if [ -z "${httpd_tags}" ]; then
      httpd_tags="yes"
    fi
    sed -i 's/MPD_PULSE_HTTPD_NAME/'"$httpd_name"'/g' /etc/mpd.conf
    sed -i 's/MPD_PULSE_HTTPD_ALWAYS_ON/'"$httpd_always_on"'/g' /etc/mpd.conf
    sed -i 's/MPD_PULSE_HTTPD_TAGS/'"$httpd_tags"'/g' /etc/mpd.conf
  else 
    if [ "$linear" == "N" ]; then
      echo "Variable MPD_PULSE_ENABLE_HTTPD set to disabled.";
    else
      echo "Variable MPD_PULSE_ENABLE_HTTPD invalid value: $MPD_PULSE_ENABLE_HTTPD";
    fi
  fi
fi

cat  /app/assets/mpd-template-pulse-final.conf >> /etc/mpd.conf

sed -i 's/REPLAYGAIN_MODE/'"$REPLAYGAIN_MODE"'/g' /etc/mpd.conf
sed -i 's/REPLAYGAIN_PREAMP/'"$REPLAYGAIN_PREAMP"'/g' /etc/mpd.conf
sed -i 's/REPLAYGAIN_MISSING_PREAMP/'"$REPLAYGAIN_MISSING_PREAMP"'/g' /etc/mpd.conf
sed -i 's/REPLAYGAIN_LIMIT/'"$REPLAYGAIN_LIMIT"'/g' /etc/mpd.conf
sed -i 's/VOLUME_NORMALIZATION/'"$VOLUME_NORMALIZATION"'/g' /etc/mpd.conf

# final output of the config file
cat /etc/mpd.conf

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

su - $USER_NAME -c "/usr/bin/mpd --no-daemon /etc/mpd.conf"
