#!/usr/bin/env bash

docker run -t -i \
  --rm \
  -u $(id -u):$(id -g) \
  --name mpd-pulse \
  --network=host \
  --volume=/run/user/$(id -u)/pulse:/run/user/$(id -u)/pulse \
  giof71/mpd-pulse:latest
