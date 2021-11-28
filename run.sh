#!/usr/bin/env bash

set -x

#echo "Searching for Docker image ..."
#DOCKER_IMAGE_ID=$(docker images --format="{{.ID}}"mpd-pulse:latest | head -n 1)
#echo "Found and using ${DOCKER_IMAGE_ID}"

USER_UID=$(id -u)

#docker run -t -i \
#  --network=host \
#  -u $(id -u):$(id -g) \
  #-e PULSE_SERVER=unix:/run/user/1000/pulse/native \
  #-e DISPLAY=unix$DISPLAY \
  #-v /tmp/.X11-unix:/tmp/.X11-unix \
  #--volume=/run/user/${USER_UID}/pulse:/run/user/1000/pulse \
#  giof71/mpd-pulse:latest


docker run -t -i \
  --rm --name mpd-pulse \
  --network=host \
  -u $(id -u):$(id -g) \
  --volume=/run/user/${USER_UID}/pulse:/run/user/1000/pulse \
  giof71/mpd-pulse:latest
