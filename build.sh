#!/usr/bin/env bash

docker build \
  --build-arg ARG_UID=$(id -u) \
  --build-arg ARG_GID=$(id -g) \
  --tag 'giof71/mpd-pulse' .
