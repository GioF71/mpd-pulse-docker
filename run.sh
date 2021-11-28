#!/usr/bin/env bash

set -x

USER_UID=$(id -u)

#docker run -t -i \
#  --rm \
#  -u $(id -u):$(id -g) \
#  --name mpd-pulse \
#  --network=host \
#  --volume=/run/user/${USER_UID}/pulse:/run/user/1001/pulse \
#  giof71/mpd-pulse:latest

docker run -t -i \
  --rm \
  -u 1000:1000 \
  --name mpd-pulse \
  --network=host \
  --volume=/run/user/${USER_UID}/pulse:/run/user/${USER_UID}/pulse \
  giof71/mpd-pulse:latest
