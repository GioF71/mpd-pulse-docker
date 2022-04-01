# mpd-pulse-docker - a Docker image for mpd with PulseAudio

## Reference

First and foremost, the reference to the awesome project:

[Music Player Daemon](https://www.musicpd.org/)

This work is inspired by [TheBiggerGuy](https://github.com/TheBiggerGuy)'s [docker-pulse-audio-example](https://github.com/TheBiggerGuy/docker-pulseaudio-example).
Without the content of that repo, I could not have created this project.
So thank you!

## Links

Source: [GitHub](https://github.com/giof71/mpd-pulse-docker)  
Images: [DockerHub](https://hub.docker.com/r/giof71/mpd-pulse)

## Why

I prepared this Dockerfile Because I wanted to be able to install mpd easily on any machine (provided the architecture is amd64 or arm). Also I wanted to be able to configure and govern the parameters easily, with particular and exclusive reference to the configuration of a single PulseAudio output. Configuring the container is easy through a webapp like Portainer.

## Prerequisites

You need to have Docker up and running on a Linux machine, and the current user must be allowed to run containers (this usually means that the current user belongs to the "docker" group).

You can verify whether your user belongs to the "docker" group with the following command:

`getent group | grep docker`

This command will output one line if the current user does belong to the "docker" group, otherwise there will be no output.

The Dockerfile and the included scripts have been tested on the following distros:

- Manjaro Linux with Gnome (amd64)

As I test the Dockerfile on more platforms, I will update this list.
I am maintaining images for arm, but I have not tried to deploy the image on a Raspberry Pi or on a Asus Tinkerboard yet.

## Get the image

Here is the [repository](https://hub.docker.com/repository/docker/giof71/mpd-pulse) on DockerHub.

Getting the image from DockerHub is as simple as typing:

`docker pull giof71/mpd-pulse:stable`

You may want to pull the "stable" image as opposed to the "latest".

## Usage

You can start mpd-pulse by simply typing:

```text
docker run --rm -it --name=mpd-pulse \
    -p 6600:6600 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /run/user/$(id -u)/pulse:/run/user/$(id -u)/pulse \
    -v ${HOME}/Music:/music:ro \
    -v ${HOME}/.mpd/playlists:/playlists \
    -v ${HOME}/.mpd/db:/db \
    giof71/mpd-pulse:stable
```

You might prefer to use `docker-compose`.
The following example assumes your username is `me` and your uid and gid are both `1000`:

```text
---
version: "3"
services:
  mpd-pulse:
    image: giof71/mpd-pulse:stable
    container_name: mpd-pulse
    ports:
      - 6600:6600
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - /run/user/1000/pulse:/run/user/1000/pulse
      - /home/me/Music:/music:ro
      - /home/me/.mpd/db:/db
      - /home/me/.mpd/playlists:/playlists
```

Note that we need to allow the container to access the pulseaudio by mounting `/run/user/$(id -u)/pulse`, which typically translates to `/run/user/1000/pulse`.  
We also need to give access to port `6600` so we can control the newly created mpd instance with our favourite mpd client.
If HTTPD output is enabled, we also need to give access to port `8000`.

Another example, with HTTPD streaming active:

```text
---
version: "3"
services:
  mpd-pulse:
    image: giof71/mpd-pulse:stable
    container_name: mpd-pulse
    ports:
      - 6600:6600
      - 8000:8000
    environment:
      - PUID=1000
      - PGID=1000
      - MPD_PULSE_ENABLE_HTTPD=yes
    volumes:
      - /run/user/1000/pulse:/run/user/1000/pulse
      - /home/me/Music:/music:ro
      - /home/me/.mpd/db:/db
      - /home/me/.mpd/playlists:/playlists
```

Available Ports:

Port|Description
:---|:---
6600|Music Player Daemon port for clients
8000|HTTPD streaming port (use when MPD_PULSE_ENABLE_HTTPD=yes)

The following tables list the volumes:

VOLUME|DESCRIPTION
:---|:---
/db|Where the mpd database is saved
/music|Where the music is stored. you might consider to mount your directory in read-only mode (`:ro`)
/playlists|Where the playlists are stored

The following tables reports all the currently supported environment variables.

VARIABLE|DEFAULT|NOTES
:---|:---:|:---
PUID|1000|The uid of your user
PGID|1000|The gid of your user
OUTPUT_NAME|mpd-pulse|PulseAudio output name
REPLAYGAIN_MODE|0|ReplayGain Mode
REPLAYGAIN_PREAMP|0|ReplayGain Preamp
REPLAYGAIN_MISSING_PREAMP|0|ReplayGain mising preamp
REPLAYGAIN_LIMIT|yes|ReplayGain Limit
VOLUME_NORMALIZATION|no|Volume normalization
QOBUZ_PLUGIN_ENABLED|no|Enables the Qobuz plugin
QOBUZ_APP_ID|ID|Qobuz application id
QOBUZ_APP_SECRET|SECRET|Your Qobuz application Secret
QOBUZ_USERNAME|USERNAME|Qobuz account username
QOBUZ_PASSWORD|PASSWORD|Qobuz account password
QOBUZ_FORMAT_ID|5|The Qobuz format identifier, i.e. a number which chooses the format and quality to be requested from Qobuz. The default is “5” (320 kbit/s MP3)
TIDAL_PLUGIN_ENABLED|no|Enables the Tidal Plugin. Note that it seems to be currently defunct: see the mpd official documentation.
TIDAL_APP_TOKEN|TOKEN|The Tidal application token. Since Tidal is unwilling to assign a token to MPD, this needs to be reverse-engineered from another (approved) Tidal client.
TIDAL_USERNAME|USERNAME|Tidal Username
TIDAL_PASSWORD|PASSWORD|Tidal password
TIDAL_AUDIOQUALITY|Q|The Tidal “audioquality” parameter. Possible values: HI_RES, LOSSLESS, HIGH, LOW. Default is HIGH.
MPD_PULSE_ENABLE_HTTPD|no|Enable HTTPD output. Values to enable: `y` or `yes`, case insentive. Remember to also expose port 8000 if you enable HTTPD.
MPD_PULSE_HTTPD_NAME|MPD_PULSE_HTTPD|HTTPD output name
MPD_PULSE_HTTPD_ALWAYS_ON|yes|HTTPD Always on. Values to enable: `y` or `yes`, case insentive.
MPD_PULSE_HTTPD_TAGS|yes|HTTPD Tags. Values to enable: `y` or `yes`, case insentive.
STARTUP_DELAY_SEC|0|Delay before starting the application. This can be useful if your container is set up to start automatically, so that you can resolve race conditions with mpd and with squeezelite if all those services run on the same audio device. I experienced issues with my Asus Tinkerboard, while the Raspberry Pi has never really needed this. Your mileage may vary. Feel free to report your personal experience.

## Caveat

Careful adding a restart policy to the container, as it needs pulseaudio. I am in no way a linux expert, but I can report that I had issues when I added `restart: unless-stopped` to my compose file. My whole desktop (Gnome at the time of the issue happening) had all sorts of audio-related issues.  
If might be better to create a user-level systemd service, and maybe a script which could automate retrieving the uid/gid for easy installation.  
This feature is something I would like to add, although I cannot provide an estimate of the availability date.  Of course, contributions are welcome.

## Build

You can build (or rebuild) the image by opening a terminal from the root of the repository and issuing the following command:

`docker build . -t giof71/mpd-pulse`

It will take very little time even on a Raspberry Pi. When it's finished, you can run the container following the previous instructions.  
Just be careful to use the tag you have built.

## Release History

Release Date|Major Changes
:---|:---
2022-04-01|Clarified doc for httpd-related environment variables
2022-04-01|Removed unused full template
2022-04-01|Fixed script checking wrong variable for httpd not enabled
2022-04-01|Validation for httpd-related environment variables
2022-04-01|Remove spurious files related to incomplete feature
2022-04-01|Add version history
2022-04-01|Updated documentation with warning about restart policies
2022-04-01|Add `README.md` to the image at path `/app/doc`
2022-03-31|Implemented optional httpd-output
2022-03-31|Base Image Bump|Bump to mpd-base-image:focal built on 2022-03-31
