# deluge-filebot-docker
<p align="center">
	<a href="https://hub.docker.com/r/gentlehoneylover/deluge-filebot/"><img alt="Docker pulls" src="https://img.shields.io/docker/pulls/gentlehoneylover/deluge-filebot?logo=docker&label=Docker%20pulls"></a>
	<a href="https://github.com/GentleHoneyLover/deluge-filebot-docker"><img alt="GitHub stars" src="https://img.shields.io/github/stars/gentlehoneylover/deluge-filebot-docker?logo=GitHub&label=GitHub%20stars&color=gold"></a>
	<a href="https://github.com/GentleHoneyLover/deluge-filebot-docker"><img alt="GitHub issues" src="https://img.shields.io/github/issues/gentlehoneylover/deluge-filebot-docker?logo=GitHub&label=GitHub%20issues"></a>
	<a href="https://actions-badge.atrox.dev/gentlehoneylover/deluge-filebot-docker/goto?ref=master"><img alt="GitHub Actions" src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fgentlehoneylover%2Fdeluge-filebot-docker%2Fbadge%3Fref%3Dmaster&style=flat" /></a>
</p><br>

[Deluge](https://deluge-torrent.org]) Bittorrent client and [FileBot](http://www.filebot.net/) renaming tool in one container. 

<p align="center">
  <img width="400" src="https://raw.githubusercontent.com/GentleHoneyLover/deluge-filebot-docker/master/logo.png" alt="Deluge + FileBot"><br>
</p>

## What is Deluge
Deluge is a lightweight, Free Software, cross-platform BitTorrent client.
- Full Encryption
- WebUI
- Plugin System
- Much more...

## What is FileBot
FileBot is the ultimate tool for renaming and organizing your movies, TV shows and Anime. Match and rename media files against online databases, download artwork and cover images, fetch subtitles, write metadata, and more, all at once in matter of seconds. It's smart and just works.

## What you get with this container
This container includes Deluge and FileBot on top of an Ubuntu image. There's also an experimental image based on Alpine (`:alpine` tag). FileBot can be be utilized via the [FileBotTool](https://github.com/Laharah/deluge-FileBotTool), a plugin for Deluge (included in the image — simply activate in the Deluge settings). Accessing the plugin settings would require a desktop Deluge client (remotely connected to the Daemon in this container) — see [Deluge User Guide](https://dev.deluge-torrent.org/wiki/UserGuide) for details.

## Installation
You can pull it from the Docker Hub via:
```sh
docker pull docker.io/gentlehoneylover/deluge-filebot:latest
```
Run it via Docker CLI or docker-compose (examples below).

The Web UI of Deluge is available at `http://<SERVER-IP>:8112` with a default password of `deluge` (can be changed in the Web UI).
Under `Preferences -> Network` Make sure to match the inbound torrent port to whatever port is mapped in the container (`57988` by default).

## Example docker CLI command:
```sh
docker run -d \
  --name=deluge \
  --restart unless-stopped \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e UMASK_SET=002 \
  -e DELUGE_LOGLEVEL=error \
  -p 8112:8112 \
  -p 57988:57988/tcp \
  -p 57988:57988/udp \
  -v /path/to/config/folder:/config \
  -v /path/to/downloads/folder:/downloads \
  -v /path/to/watchfolder:/watchfolder
  docker.io/gentlehoneylover/deluge-filebot:latest
```

## Example compose file:
```yaml
version: "3"
services:
  deluge-filebot:
    container_name: deluge-filebot
    image: docker.io/gentlehoneylover/deluge-filebot:latest
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - UMASK_SET=002 #optional
      - DELUGE_LOGLEVEL=error #optional
    ports:
      - 8112:8112 #web-ui port 
      - 58846:58846 #deluge daemon port
      - 57988:57988/tcp #inbound tcp torrent port
      - 57988:57988/udp #inbound udp torrent port
    volumes:
      - /path/to/config/folder:/config
      - /path/to/downloads/folder:/downloads
      - /path/to/watchfolder:/watchfolder
```

## Environment variables
|        Variable         | What it does                                                                                       |
| :---------------------: | -------------------------------------------------------------------------------------------------- |
|       `PUID=1000`       | Sets user ID to a specific value (to match user on the host)                                       |
|       `PGID=1000`       | Sets group ID to a specific value (to match user group on the host)                                |
|     `UMASK_SET=002`     | Sets [umask](https://en.wikipedia.org/wiki/Umask) under which files are created (default is `002`) |
|   `TZ=Europe/London`    | Specify a timezone to use                                                                          |
| `DELUGE_LOGLEVEL=error` | Set the loglevel output when running Deluge (default is `warning`)                                 |

## Ports
|  Port   | What it is for                                                         |
| :-----: | ---------------------------------------------------------------------- |
| `8112`  | Default port used by Web UI                                            |
| `58846` | Default port used by deluge daemon to allow desktop client connections |
| `57988` | Inbound torrent traffic                                                |

## Volumes
|     Volume     | What it is for                                                       |
| :------------: | -------------------------------------------------------------------- |
|   `/config`    | Folder where Deluge and FileBot keep config files                    |
|  `/downloads`  | Folder for downloaded files                                          |
| `/watchfolder` | A folder Deluge should be watching to auto-pickup new .torrent files |