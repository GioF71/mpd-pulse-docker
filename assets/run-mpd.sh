#!/bin/sh

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

### add user to sudoers
SUDOERS_FILE="/etc/sudoers.d/${USER_NAME}"
if [ ! -f $SUDOERS_FILE ]; then 
  echo "Sudoers file [$SUDOERS_FILE] not found, creating..."
  mkdir -p /etc/sudoers.d
  echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > $SUDOERS_FILE
  chmod 0440 $SUDOERS_FILE
  ls -la $SUDOERS_FILE
  cat $SUDOERS_FILE
else 
  echo "Sudoers file [$SUDOERS_FILE] already exists."
fi

PULSE_CLIENT_CONF="/etc/pulse/client.conf"

echo "Creating pulseaudio configuration file $PULSE_CLIENT_CONF..."
cp /app/assets/pulse-client-template.conf $PULSE_CLIENT_CONF
sed -i 's/PUID/'"$PUID"'/g' $PULSE_CLIENT_CONF
cat $PULSE_CLIENT_CONF

cp /app/assets/mpd-template.conf /etc/mpd.conf

sed -i 's/USER_NAME/'"$USER_NAME"'/g' /etc/mpd.conf

cat /etc/mpd.conf

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

sed -i 's/REPLAYGAIN_MODE/'"$REPLAYGAIN_MODE"'/g' /etc/mpd.conf
sed -i 's/REPLAYGAIN_PREAMP/'"$REPLAYGAIN_PREAMP"'/g' /etc/mpd.conf
sed -i 's/REPLAYGAIN_MISSING_PREAMP/'"$REPLAYGAIN_MISSING_PREAMP"'/g' /etc/mpd.conf
sed -i 's/REPLAYGAIN_LIMIT/'"$REPLAYGAIN_LIMIT"'/g' /etc/mpd.conf
sed -i 's/VOLUME_NORMALIZATION/'"$VOLUME_NORMALIZATION"'/g' /etc/mpd.conf

cat /etc/mpd.conf

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

su - $USER_NAME -c "/usr/bin/mpd --stderr --no-daemon /etc/mpd.conf"
