#!/usr/bin/env bash

docker run -d \
  --name=mpd-pulse \
  -u $(id -u):$(id -g) \
  --name mpd-pulse \
  --network=host \
  --volume=/run/user/$(id -u)/pulse:/run/user/$(id -u)/pulse \
  giof71/mpd-pulse:latest
