<p align="center">
  <img width="400" src="logo.png" alt="Deluge + FileBot"><br><br>
</p>

# deluge-filebot-docker
[Deluge](https://deluge-torrent.org]) Bittorrent client and [FileBot](http://www.filebot.net/) renaming tool in one container.

## What is Deluge
Deluge is a lightweight, Free Software, cross-platform BitTorrent client.
- Full Encryption
- WebUI
- Plugin System
- Much more...

## What is FileBot
FileBot is the ultimate tool for renaming and organizing your movies, TV shows and Anime. Match and rename media files against online databases, download artwork and cover images, fetch subtitles, write metadata, and more, all at once in matter of seconds. It's smart and just works.

## What do you get with this container
This container includes Deluge and FileBot on top of an Ubuntu image. FileBot can be be utilized via the [FileBotTool](https://github.com/Laharah/deluge-FileBotTool), a plugin for Deluge. Accessing the plugin settings would require a desktop Deluge client — as Web UI is not supported by the plugin.

## Example compose file:
```yaml
version: "3"
services:
deluge-filebot:
    container_name: deluge-filebot
    image: docker.io/gentlehoneylover/deluge-filebot
    restart: unless-stopped
    environment:
      - PUID=<your-user-id>
      - PGID=<your-group-id>
      - TZ=Europe/London
      - UMASK_SET=022 #optional
      - DELUGE_LOGLEVEL=error #optional
    ports:
      - 8112:8112 #web-ui port 
      - 58846:58846 #deluge daemon port
    volumes:
      - /path/to/config/folder:/config
      - /path/to/downloads/folder:/downloads
      - /path/to/watchfolder:/watchfolder
    restart: unless-stopped
```

## Environment variables
| Variable | What it does |
| :----: | --- |
| `PUID=1000` | Sets user ID to a specific value (to match user on the host) |
| `PGID=1000` | Sets group ID to a specific value (to match user group on the host) |
| `UMASK_SET=022` | Sets [umask](https://en.wikipedia.org/wiki/Umask) under which files are created (default is `022`)
| `TZ=Europe/London` | Specify a timezone to use |
| `DELUGE_LOGLEVEL=error` | Set the loglevel output when running Deluge, default is `info` for deluged and `warning` for delgued-web |

## Ports
| Port | What it is for |
| :----: | --- |
| `8112` | Default port used by Web UI |
| `58846` | Default port used by deluge daemon to allow desktop client connections |

## Volumes
| Volume | What it is for |
| :----: | --- |
| `/config` | Folder where Deluge and FileBot keep config files |
| `/downloads` | Folder for downloaded files |
| `/watchfolder` | A folder Deluge should be watching to auto-pickup new .torrent files |