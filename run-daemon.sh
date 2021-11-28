#!/usr/bin/env bash

set -x

USER_UID=$(id -u)
GROUP_UID=$(id -g)

echo "USER_UID = ${USER_UID}"
echo "GROUP_UID = ${GROUP_UID}"

docker run -d \
  --name=mpd-pulse \
  -u $USER_UID:$GROUP_UID \
  --name mpd-pulse \
  --network=host \
  --volume=/run/user/${USER_UID}/pulse:/run/user/${USER_UID}/pulse \
  giof71/mpd-pulse:latest
